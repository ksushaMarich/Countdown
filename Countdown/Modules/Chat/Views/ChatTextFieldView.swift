import UIKit

class ChatTextFieldView: UIView {
    enum Constants {
        static let textColor = UIColor.white
        static let placeholederColor = UIColor.init(hex: 0xFEFEFE).withAlphaComponent(0.6)
        static let placeholederText = "Message"
    }
    
    private let sendHandler: (String) -> Void
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white.withAlphaComponent(0.1)
        textView.cornerRadius(18)
        textView.font = .systemFont(ofSize: 18)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        textView.text = Constants.placeholederText
        textView.textColor = Constants.placeholederColor
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = CustomButton { [weak self] in
            let text = self?.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let text = text,
                  text.isEmpty == false,
                  text != Constants.placeholederText else {
                return
            }
            self?.sendHandler(text)
            self?.textView.text = ""
        }
        button.setupImage("chat-send")
        button.isEnabled(false)
        return button
    }()
    
    init(sendHandler: @escaping (String) -> Void) {
        self.sendHandler = sendHandler
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        textView.text = text
        textView.textColor = Constants.textColor
    }
    
    func showKeyboard() {
        textView.becomeFirstResponder()
    }
    
    private func setupView() {
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(38)
        }
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(38)
            make.bottom.equalTo(textView)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(textView.snp.trailing).inset(-8)
        }
    }
    
    private func clear() {
        textView.text = Constants.placeholederText
        textView.textColor = Constants.placeholederColor
        textView.resignFirstResponder()
    }
}


extension ChatTextFieldView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.placeholederText {
            textView.text = nil
            textView.textColor = Constants.textColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholederText
            textView.textColor = Constants.placeholederColor
        }
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let maxLength = 40
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        sendButton.isEnabled(newText.count > 0)
        return newText.count <= maxLength
    }
}

import UIKit

class CustomTextField: UITextField {
    
    var insetX: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    var insetY: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX , insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX , insetY)
    }
    
    private let textChangeHandler: (String) -> Void
    private let maxLeght: Int?
    
    init(maxLeght: Int? = nil, textChangeHandler: @escaping (String) -> Void) {
        self.maxLeght = maxLeght
        self.textChangeHandler = textChangeHandler
        super.init(frame: .zero)
        
        delegate = self
        tintColor = .gray
        font = .systemFont(ofSize: 12)
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        attributedPlaceholder = NSAttributedString(
            string: "Placeholder Text",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textChangeHandler(textField.text ?? "")
    }
}

extension UITextField {
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let maxLeght = maxLeght else { return true }
        
        let newLength = text.count + string.count - range.length
        return newLength <= maxLeght
    }
    //    func textField(_ textField: UITextField,
    //                   shouldChangeCharactersIn range: NSRange,
    //                   replacementString string: String) -> Bool {
    //
    //        guard let charactersCount = textField.text?.count else {
    //            return false
    //        }
    //
    //        if string.isInt {
    //            return true
    //        }
    //
    //        if string == "-", textField.text == "" {
    //            return true
    //        }
    //
    //        if string.isBackspace {
    //            return true
    //        }
    //
    //        return false
    //    }
}

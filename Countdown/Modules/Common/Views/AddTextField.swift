import UIKit

class AddTextFieldView: UIView {
    private let textChangeHandler: ((String) -> Void)?
    
    //private let title: String
    private let placeholderText: String
    private let imageName: String?
    private let datePickerMode: UIDatePicker.Mode?
    
    //private lazy var titleLabel = UIView.boldLabel(title, fontSize: 14, textColor: .init(hex: 0xFF8C82))
    private(set) lazy var placeholderLabel = UIView.systemLabel(placeholderText, fontSize: 14, textColor: .init(hex: 0x5E5E5E))
    private(set) lazy var textField = CustomTextField { [weak self] text in
        guard let self = self else { return }
        if text == "" {
            self.placeholderLabel.isHidden = false
        } else {
            self.placeholderLabel.isHidden = true
        }
        
        self.textChangeHandler?(text)
    }
    
    init(
        //title: String,
        placeholderText: String,
        imageName: String? = nil,
        keyboardType: UIKeyboardType? = nil,
        datePickerMode: UIDatePicker.Mode? = nil,
        textChangeHandler: ((String) -> Void)? = nil
    ) {
        self.textChangeHandler = textChangeHandler
        //self.title = title
        self.placeholderText = placeholderText
        self.datePickerMode = datePickerMode
        self.imageName = imageName
        super.init(frame: .zero)
        setupView()
        // SETUP
        textField.textColor = .white
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        backgroundColor = .white
//        cornerRadius(10)
        textField.placeholder = ""
//        addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
        
        let view = UIView.empty().cornerRadius(10).applyBorder(color: .white, width: 1).backgroundColor(.init(hex: 0x20232A))
        
        if let imageName = imageName {
            let imageView = UIView.imageView(imageName)
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(14)
                make.centerY.equalToSuperview()
                make.size.equalTo(14)
            }
        }
        
        if let datePickerMode = datePickerMode {
            let picker = CustomDatePicker(mode: datePickerMode) { [weak self] date in
                let formate: String
                
                if datePickerMode == .time {
                    formate = "HH:mm"
                } else {
                    formate = "MM.dd.yyyy"
                }
                
                self?.placeholderLabel.text = date.formate(formate)
                self?.placeholderLabel.textColor = self?.textField.textColor ?? .black
                self?.textChangeHandler?(date.formate(formate))
            }
            picker.alpha = 0.1
            view.addSubview(picker)
            picker.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(14)
                make.centerY.equalToSuperview()
            }
        }
        
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            if imageName == nil {
                make.trailing.equalToSuperview().inset(14)
            } else {
                make.trailing.equalToSuperview().inset(8 + 14 + 8)
            }
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        if datePickerMode == nil {
            view.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.centerY.equalTo(placeholderLabel)
                make.leading.trailing.equalTo(placeholderLabel)
            }
        }
        placeholderLabel.backgroundColor(.init(hex: 0x20232A))
        
        addSubview(view)
        view.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(34)
        }
        
//        let lineView = UIView.empty().height(1).backgroundColor(.init(hex: 0xFF8C82))
//        view.addSubview(lineView)
//        lineView.snp.makeConstraints { make in
//            make.bottom.leading.trailing.equalToSuperview()
//        }
    }
}

class CustomDatePicker: UIDatePicker {
    private let dateChangeHandler: (Date) -> Void
    
    init(mode: UIDatePicker.Mode,dateChangeHandler: @escaping (Date) -> Void) {
        self.dateChangeHandler = dateChangeHandler
        super.init(frame: .zero)
        
        self.overrideUserInterfaceStyle = .dark
        self.datePickerMode = mode
        addTarget(self, action: #selector(textFieldDidChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ datePicker: UIDatePicker) {
        dateChangeHandler(datePicker.date)
    }
}

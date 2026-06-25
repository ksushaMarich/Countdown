
import UIKit
import SnapKit

protocol CustomSearchBarDelegate: AnyObject {
    func textEntered(_ text: String)
}

final class CustomSearchBar: UIControl {
    
    //MARK: - Naming
    
    weak var delegate: CustomSearchBarDelegate?
    
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    private lazy var loupeImageView = UIImageView(image: .loupe)
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = InterFont.regular.of(size: 20)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.searchBarBlack.withAlphaComponent(0.6)
            ]
        )
        return textField
    }()
    
    
    //MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVeiw()
        configureLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupVeiw() {
        
        addSubview(loupeImageView)
        addSubview(textField)
        
        loupeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(loupeImageView)
            make.leading.equalTo(loupeImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func configureLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.themeRed.withAlphaComponent(0.2).cgColor
    }
}

extension CustomSearchBar: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            delegate?.textEntered(text.replacingCharacters(in: textRange, with: string))
        }
        return true
    }
}

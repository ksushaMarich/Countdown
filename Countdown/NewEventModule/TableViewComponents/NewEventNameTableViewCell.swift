
import UIKit

protocol NewEventNameTableViewCellDelegate: AnyObject {
    func eventNameСhanged(_ newName: String)
}

final class NewEventNameTableViewCell: RoundedTableViewCell {
    
    //MARK: - Naming
    
    static let identifier = "NewEventNameTableViewCell"
    
    weak var delegate: NewEventNameTableViewCellDelegate?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = InterFont.regular.of(size: 20)
        textField.attributedPlaceholder = NSAttributedString(
            string: "New event",
            attributes: [
                .foregroundColor: UIColor.blackFont,
                .font: InterFont.regular.of(size: 20)
        ])
        textField.delegate = self
        return textField
    }()
    
    //MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setupCell() {
        
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(14)
        }
    }
    
    func configure(name: String?) {
        super.configure(position: nil)
        if let name {
            textField.text = name
        }
    }
}

extension NewEventNameTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        if let stringRange = Range(range, in: currentText) {
            delegate?.eventNameСhanged(currentText.replacingCharacters(in: stringRange, with: string))
        }
        return true
    }
}

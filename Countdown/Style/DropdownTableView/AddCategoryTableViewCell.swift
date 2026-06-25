
import UIKit

class AddCategoryTableViewCell: UITableViewCell {

    //MARK: - Naming
    
    static var identifier = "AddCategoryTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new category"
        label.font = InterFont.medium.of(size: 20)
        label.textColor = .themeRed
        return label
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-19)
        }
    }
}

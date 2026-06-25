
import UIKit

class EventCategoryTableViewCell: RoundedTableViewCell {

    //MARK: - Naming
    
    static let identifier = "EventCategoryTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .blackFont
        return label
    }()
    
    private lazy var categoryValueView: UIView = {
        let view = UIView()
        view.backgroundColor = .labelBackgroundGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var categoryColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .redCategory
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Private event"
        label.font = InterFont.regular.of(size: 16)
        label.textAlignment = .center
        return label
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
    
    func configure(with option: String, color: UIColor?) {
        valueLabel.text = option
        categoryColorView.backgroundColor = color
    }
    
    private func setupCell() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryValueView)
        
        categoryValueView.addSubview(categoryColorView)
        categoryValueView.addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(14)
            make.leading.equalTo(20)
        }
        
        categoryValueView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        categoryColorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(6)
            make.leading.equalToSuperview().offset(12)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalTo(categoryColorView.snp.trailing).offset(8)
        }
    }
}

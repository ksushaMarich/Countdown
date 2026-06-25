
import UIKit

class EventAlertTableViewCell: RoundedTableViewCell {
    
    //MARK: - Naming
    
    static let identifier = "EventAlertTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Alert"
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .blackFont
        return label
    }()
    
    private lazy var valueView: UIView = {
        let view = UIView()
        view.backgroundColor = .labelBackgroundGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "At time of event"
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
    
    func configure(with option: String) {
        valueLabel.text = option
    }
    
    private func setupCell() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueView)
        valueView.addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(14)
            make.leading.equalTo(20)
        }
        
        valueView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
    }
}

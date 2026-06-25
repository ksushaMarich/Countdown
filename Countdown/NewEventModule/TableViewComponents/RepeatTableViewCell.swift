
import UIKit
import SnapKit

class RepeatTableViewCell: RoundedTableViewCell {

    //MARK: - Naming
    
    static let identifier = "RepeatTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Repeat"
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .blackFont
        return label
    }()
    
    private lazy var repeatValueView: UIView = {
        let view = UIView()
        view.backgroundColor = .labelBackgroundGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var repeatValueLabel: UILabel = {
        let label = UILabel()
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
        repeatValueLabel.text = option
    }
    
    private func setupCell() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(repeatValueView)
        repeatValueView.addSubview(repeatValueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(14)
            make.leading.equalTo(20)
        }
        
        repeatValueView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        repeatValueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
    }
}

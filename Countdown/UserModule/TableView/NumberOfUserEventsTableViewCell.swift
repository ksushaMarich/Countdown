
import UIKit

class NumberOfUserEventsTableViewCell: RoundedTableViewCell {

    //MARK: - Naming
    
    static let identifier = "NumberOfUserEventsTableViewCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Events count"
        label.font = InterFont.regular.of(size: 16)
        return label
    }()
    
    private lazy var numberOfEventsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed.withAlphaComponent(0.2)
        return view
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        contentView.addSubview(label)
        contentView.addSubview(numberOfEventsLabel)
        contentView.addSubview(separatorView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(16))
        }
        
        numberOfEventsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(-16))
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(16))
            make.height.equalTo(1)
        }
    }
    
    func configure(with nubmer: String, position: CellPosition) {
        super.configure(position: position)
        self.numberOfEventsLabel.text = nubmer
        
        if cellPosition == .bottom || position == .single {
           separatorView.backgroundColor = .clear
        } else {
            separatorView.backgroundColor = .themeRed.withAlphaComponent(0.2)
        }
    }
}

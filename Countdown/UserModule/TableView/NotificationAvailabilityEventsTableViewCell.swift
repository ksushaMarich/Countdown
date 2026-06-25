
import UIKit

protocol NotificationAvailabilityTableViewCellDelegate: AnyObject {
    func availabilityChanged(_ value: Bool)
}

class NotificationAvailabilityTableViewCell: RoundedTableViewCell  {
    //MARK: - Naming
    
    weak var delegate: NotificationAvailabilityTableViewCellDelegate?
    
    static let identifier = "NotificationAvailabilityTableViewCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notification"
        label.font = InterFont.regular.of(size: 16)
        return label
    }()
    
    private lazy var privateEventsSwitch: UISwitch = {
        let privateEventsSwitch = UISwitch()
        privateEventsSwitch.translatesAutoresizingMaskIntoConstraints = false
        privateEventsSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return privateEventsSwitch
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
        contentView.addSubview(privateEventsSwitch)
        contentView.addSubview(separatorView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(16))
        }
        
        privateEventsSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(-10))
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(16))
            make.height.equalTo(1)
        }
    }
    
    func configure(isNotificationAvailable: Bool) {
        super.configure(position: .bottom)
        self.privateEventsSwitch.isOn = isNotificationAvailable
        separatorView.backgroundColor = .clear
    }
    
    @objc func valueChanged() {
        delegate?.availabilityChanged(privateEventsSwitch.isOn)
    }
}

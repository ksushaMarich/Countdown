
import UIKit
import SnapKit

protocol WidgetTableViewCellDelegate: AnyObject {
    func addWidget()
    func upgradeToPro()
    func newWidgetBackgroundStateIsSelected(_ state: WidgetBackgroundState)
    func presentPaywall()
}

final class WidgetTableViewCell: UITableViewCell{
    
    //MARK: - Naming
    
    static let identifier = "WidgetTableViewCell"
    
    weak var delegate: WidgetTableViewCellDelegate?
    
    // MARK: - Upgrade to pro
    
    private lazy var upgradeToProPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Get access to widget with Pro Version"
        label.font = InterFont.regular.of(size: 16)
        label.textColor = .purpleFont
        return label
    }()
    
    private lazy var proStarImageView = UIImageView(image: .proStar)
    
    private lazy var upgradeToProStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ upgradeToProPromptLabel, proStarImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upgradeToProTapped)))
        return stackView
    }()
    
    private lazy var setupWidgetControl: SetupWidgetControl = {
        let setupWidgetControl = SetupWidgetControl()
        setupWidgetControl.delegate = self
        return setupWidgetControl
    }()
    
    private lazy var addWidgetButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = InterFont.regular.of(size: 24)
        button.setTitle("Add widget", for: .normal)
        button.backgroundColor = .widgetPurple
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(addWidgetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.borderColor = UIColor.widgetPurple.cgColor
        layer.borderWidth = 1
        contentView.backgroundColor = .widgetPurple.withAlphaComponent(0.1)
        layer.masksToBounds = true
        layer.cornerRadius = 8
        selectionStyle = .none
        setup()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setup() {
        
        contentView.addSubview(upgradeToProStackView)
        contentView.addSubview(setupWidgetControl)
        contentView.addSubview(addWidgetButton)
        
        upgradeToProStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(20)
        }
        
        proStarImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        
        setupWidgetControl.snp.makeConstraints { make in
            make.top.equalTo(upgradeToProStackView.snp.bottom).offset(CGFloat.proportionalToDesignHeight(28))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(491))
        }
        
        addWidgetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-19)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(58))
        }
    }
    
    func configure(with event: Event) {
        setupWidgetControl.configure(with: event)
    }
    
    @objc private func addWidgetButtonTapped() {
        delegate?.addWidget()
    }
    
    @objc private func upgradeToProTapped() {
        delegate?.upgradeToPro()
    }
}

extension WidgetTableViewCell: SetupWidgetControlDelegate {
    func newWidgetBackgroundStateIsSelected(_ state: WidgetBackgroundState) {
        delegate?.newWidgetBackgroundStateIsSelected(state)
    }
    
    func presentPaywall() {
        delegate?.presentPaywall()
    }
}

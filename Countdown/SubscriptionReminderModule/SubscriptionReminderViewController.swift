
import UIKit

class SubscriptionReminderViewController: UIViewController {
    
    //MARK: - Naming
    
    var presenter: SubscriptionReminderViewOutput?
    
    private let grabberViewHeight: CGFloat = CGFloat.proportionalToDesignHeight(5)
    private let addwidgetButtonHeight: CGFloat = CGFloat.proportionalToDesignHeight(62)
    private let setupWidgetControlHeight: CGFloat =  CGFloat.proportionalToDesignHeight(393)
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.lightPurple.cgColor,
            UIColor.darkPurple.cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.frame = view.bounds
        return layer
    }()
    
    private lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = grabberViewHeight / 2
        return view
    }()
    
    private lazy var countdownsInfoLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.medium.of(size: 28)
        label.text = "You’ve added your first countdown"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var upgradeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.regular.of(size: 20)
        label.text = "Bring color in your life\nAdd widgets with pro version"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        return label
    }()
    
    private lazy var addwidgetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitle("Add widget", for: .normal)
        button.titleLabel?.font = HelveticaNeueFont.medium.of(size: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = addwidgetButtonHeight / 2
        button.addTarget(self, action: #selector(addwidgetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.regular.of(size: 12)
        label.text = "Only $ 9,49 / Year"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        label.alpha = 0.6
        label.isHidden = true
        return label
    }()
    
    private lazy var setupWidgetControl: SetupWidgetControl = {
        let control = SetupWidgetControl(isSubscriptionReminder: true)
        return control
    }()
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupView()
    }
    
    //MARK: - Methods
    
    private func setupView() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(grabberView)
        view.addSubview(countdownsInfoLabel)
        view.addSubview(upgradeInfoLabel)
        view.addSubview(priceLabel)
        view.addSubview(addwidgetButton)
        view.addSubview(setupWidgetControl)
        
        grabberView.snp.makeConstraints { make in
            make.height.equalTo(grabberViewHeight)
            make.width.equalTo(CGFloat.proportionalToDesignWidth(77))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(10))
        }
        
        countdownsInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(grabberView.snp.bottom).offset(CGFloat.proportionalToDesignHeight(25))
            make.height.equalTo(CGFloat.proportionalToDesignHeight(34))
            make.width.equalTo(CGFloat.proportionalToDesignWidth(331))
            make.centerX.equalToSuperview()
        }
        
        upgradeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(countdownsInfoLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(11))
            make.height.equalTo(CGFloat.proportionalToDesignHeight(54))
            make.width.equalTo(CGFloat.proportionalToDesignWidth(271))
            make.centerX.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(-41))
            make.height.equalTo(CGFloat.proportionalToDesignHeight(14))
            make.width.equalTo(CGFloat.proportionalToDesignWidth(91))
            make.centerX.equalToSuperview()
        }
        
        addwidgetButton.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.top).offset(CGFloat.proportionalToDesignHeight(-11))
            make.height.equalTo(addwidgetButtonHeight)
            make.width.equalTo(CGFloat.proportionalToDesignWidth(353))
            make.centerX.equalToSuperview()
        }
        
        setupWidgetControl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(upgradeInfoLabel.snp.bottom).offset(28)
            make.bottom.equalTo(addwidgetButton.snp.top).offset(-27)
        }
    }
    
    @objc private func addwidgetButtonTapped() {
        presenter?.addwidgetButtonTapped()
    }
}

extension SubscriptionReminderViewController: SubscriptionReminderViewInput {
    func configureViewWithEvent(_ event: Event) {
        setupWidgetControl.configure(with: event)
    }
}

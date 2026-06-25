
import UIKit
import SnapKit

final class GreetingViewController: UIViewController {
    
    // MARK: Naming
    
    var presenter: GreetingViewOutput?
    
    private lazy var titleLabel = UIElements.eventsTitleLabel
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You still don’t have any \nevents in your schedule"
        label.font = InterFont.regular.of(size: 24)
        label.textColor = .grayFont
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var greetingImageView = UIImageView(image: .greeting)
    
    private lazy var newEventButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.setTitle("Create a new event", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = InterFont.medium.of(size: 24)
        button.backgroundColor = .themeRed
        button.addTarget(self, action: #selector(newEventButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = InterFont.medium.of(size: 16)
        label.textAlignment = .center
        label.textColor = .blackFont
        label.sizeToFit()
        return label
    }()
    
    private lazy var importEventLabel: UILabel = {
        let button = UILabel()
        button.text = "Import events from calendar"
        button.textColor = .themeRed
        button.font = InterFont.medium.of(size: 20)
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(importEventButtonTapped)))
        return button
    }()
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        if #available(iOS 18.0, *) {
            tabBarController?.setTabBarHidden(true, animated: animated)
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if #available(iOS 18.0, *) {
            tabBarController?.setTabBarHidden(true, animated: animated)
        }
    }
    
    //MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .launchBackground
        let importEventFont = importEventLabel.font
        let separatorFont = separatorLabel.font
        
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(greetingImageView)
        view.addSubview(newEventButton)
        view.addSubview(separatorLabel)
        view.addSubview(importEventLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset( CGFloat.proportionalToDesignHeight(73))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(20))
            make.height.equalTo(CGFloat.proportionalToDesignHeight(42))
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(8))
            make.leading.equalTo(titleLabel)
            make.height.equalTo(64)
        }
        
        greetingImageView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(31))
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(299))
            make.width.equalTo(greetingImageView.snp.height)
        }
        
        newEventButton.snp.makeConstraints { make in
            make.top.equalTo(greetingImageView.snp.bottom).offset(CGFloat.proportionalToDesignHeight(132))
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(58))
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.top.equalTo(newEventButton.snp.bottom).offset(-((separatorFont?.ascender ?? 0) - (separatorFont?.capHeight ?? 0)) + 10)
            make.centerX.equalToSuperview()
        }
        
        importEventLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLabel.snp.bottom).offset(-((importEventFont?.ascender ?? 0) - (importEventFont?.capHeight ?? 0)) + 5)
            make.centerX.equalToSuperview()
            make.height.equalTo(CGFloat.proportionalToDesignHeight(24))
        }
    }
    
    @objc private func newEventButtonTapped() {
        presenter?.newEventButtonTapped()
    }
    
    @objc private func importEventButtonTapped() {
        presenter?.importEventButtonTapped()
    }
}

extension GreetingViewController: GreetingViewInput {}

extension GreetingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

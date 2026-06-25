
import UIKit

final class PaywallViewController: PartialModalViewController {
    
    //MARK: - Naming
    
    var presenter: PaywallViewOutput?
    
    
    private lazy var loadingView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
           view.translatesAutoresizingMaskIntoConstraints = false
           view.isHidden = true
           
           let activity = UIActivityIndicatorView(style: .large)
           activity.color = .white
           activity.startAnimating()
           activity.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(activity)
           
           NSLayoutConstraint.activate([
               activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
           
           return view
       }()
    
    
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subscription plans"
        label.font = InterFont.medium.of(size: 24)
        label.textColor = .white
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = """
            Unlock the full countdown experience!
            • Unlimited events
            • Calendar import
            • Widget customization
            """
        label.font = InterFont.regular.of(size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PaywallTableViewCell.self, forCellReuseIdentifier: PaywallTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var termsOfUseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        let attributedString = NSAttributedString(
            string: "Terms of Use",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.lightGray
            ]
        )
        label.attributedText = attributedString
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTermsOfUse)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        let attributedString = NSAttributedString(
            string: "Privacy Policy",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.lightGray
            ]
        )
        label.attributedText = attributedString
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicy)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var linksStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [termsOfUseLabel, privacyPolicyLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = CGFloat.proportionalToDesignWidth(24)
        return stackView
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupSheetView()
        
        setupLoader()
    }
    
    private func setupLoader() {
           view.addSubview(loadingView)
           NSLayoutConstraint.activate([
               loadingView.topAnchor.constraint(equalTo: view.topAnchor),
               loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }
       
    func showLoader() {
        loadingView.isHidden = false
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
    
    //MARK: - Methods
    
    override func getVisibleContentHeight() -> CGFloat {
        return CGFloat.proportionalToDesignHeight(590)
    }
    
    private func setupSheetView() {
        sheetView.layer.insertSublayer(gradientLayer, at: 0)
        grabberView.backgroundColor = .white.withAlphaComponent(0.8)
        
        sheetView.addSubview(titleLabel)
        sheetView.addSubview(subtitleLabel)
        sheetView.addSubview(tableView)
        sheetView.addSubview(linksStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(40))
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(20))
            make.height.equalTo(29)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(6))
            make.leading.equalTo(titleLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        linksStackView.snp.makeConstraints { make in
            make.bottom.equalTo(sheetView.safeAreaLayoutGuide.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom)
            make.leading.equalTo(subtitleLabel)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(linksStackView.snp.top).offset(CGFloat.proportionalToDesignHeight(-10))
        }
    }
    
    @objc func openTermsOfUse() {
        presenter?.presentWebView(with: .termsOfUse)
    }
    
    @objc func openPrivacyPolicy() {
        presenter?.presentWebView(with: .privacyPolicy)
    }
}

extension PaywallViewController: PaywallViewInput {
    func reloadProducts() {
        tableView.reloadData()
    }
}

extension PaywallViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat.proportionalToDesignHeight(92)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.proportionalToDesignHeight(20)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: PaywallTableViewCell.identifier) as? PaywallTableViewCell,
            let product = presenter?.products[indexPath.section]
        else { return UITableViewCell() }
        
        cell.configure(with: product)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.productSelected(at: indexPath.section)
    }
}

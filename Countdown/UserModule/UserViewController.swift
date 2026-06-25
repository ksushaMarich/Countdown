

import UIKit

class UserViewController: UIViewController {
    
    //MARK: - Naming
    
    var presenter: UserEventViewOutput?
    
    private lazy var getProButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("  🚀 Get Pro  ", for: .normal)
        button.titleLabel?.font = InterFont.regular.of(size: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .themeRed
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(getProButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BaseUserTableViewCell.self, forCellReuseIdentifier: BaseUserTableViewCell.identifier)
        tableView.register(NumberOfUserEventsTableViewCell.self, forCellReuseIdentifier: NumberOfUserEventsTableViewCell.identifier)
        tableView.register(PrivateUsersEventsTableViewCell.self, forCellReuseIdentifier: PrivateUsersEventsTableViewCell.identifier)
        tableView.register(NotificationAvailabilityTableViewCell.self, forCellReuseIdentifier: NotificationAvailabilityTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
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
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        navigationItem.title = "Profile"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: InterFont.regular.of(size: 20),
            .foregroundColor: UIColor.blackFont
        ]
        setupView()
        setupLoader() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    //MARK: - Methods
    
    private func setupView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat.proportionalToDesignWidth(16)),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat.proportionalToDesignWidth(-16))
        ])
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
    
    private func showLoader() {
        loadingView.isHidden = false
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
    
    @objc func getProButtonTapped() {
        presenter?.presentPaywall()
    }
}

extension UserViewController: UserEventViewInput {
    
    func setGetProButton() {
        navigationItem.rightBarButtonItem = getProButton
    }
    
    func updateNumberOfUserEvents(with number: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NumberOfUserEventsTableViewCell else { return }
        cell.configure(with: "\(number)", position: .top)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        default:
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row >= 2, indexPath.row < 5  {
                let titles = ["Buy premium", "Restore Purchases", "Support"]
                guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseUserTableViewCell.identifier) as? BaseUserTableViewCell else { return UITableViewCell() }
                cell.configure(with: titles[indexPath.row - 2], position: .middle)
                return cell
            } else if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NumberOfUserEventsTableViewCell.identifier) as? NumberOfUserEventsTableViewCell else { return UITableViewCell ()}
                cell.configure(with: "\(presenter?.eventsCount ?? 0)", position: .top)
                return cell
            } else if indexPath.row == 5 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationAvailabilityTableViewCell.identifier) as? NotificationAvailabilityTableViewCell else { return UITableViewCell ()}
                cell.configure(isNotificationAvailable: presenter?.getIsNotificationsVisible() ?? false)
                cell.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivateUsersEventsTableViewCell.identifier) as? PrivateUsersEventsTableViewCell else { return UITableViewCell ()}
                cell.configure(isPrivateAvailable: presenter?.getIsPrivateEventsVisible() ?? false, position: .middle)
                cell.delegate = self
                return cell
            }
        default:
            let titles = ["Privacy policy", "Terms of use"]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseUserTableViewCell.identifier) as? BaseUserTableViewCell else { return UITableViewCell() }
            cell.configure(with: titles[indexPath.row], position: indexPath.row == 0 ? .top : .bottom)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        switch section {
        case 0:
            let headerView = UIView()
            let titleLabel = UILabel()
            titleLabel.text = "Account"
            titleLabel.font = InterFont.regular.of(size: 16)
            titleLabel.textColor = .black
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
                titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
            ])
            
            return headerView
            
        default:
            let headerView = UIView()
            let titleLabel = UILabel()
            titleLabel.text = "Documents"
            titleLabel.font =  InterFont.regular.of(size: 16)
            titleLabel.textColor = .black
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
                titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
            ])
            
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 2, section: 0) {
            presenter?.presentPaywall()
        } else if indexPath == IndexPath(row: 3, section: 0) {
            self.showLoader()
            Task.detached {
                do {
                    try await self.presenter?.restorePurchases()
                    
                    await self.hideLoader()
                } catch {
                    await self.hideLoader()
                }
            }
        } else if indexPath == IndexPath(row: 0, section: 1) {
            presenter?.presentDocuments(wiht: .privacyPolicy)
        } else if indexPath == IndexPath(row: 1, section: 1) {
            presenter?.presentDocuments(wiht: .termsOfUse)
        } else if indexPath == IndexPath(row: 4, section: 0) {
            presenter?.openMail()
        }
    }
    
    func showSuccessRestoreAlert() {
        showAlert(title: "Congratulations!", message: "You already have an active subscription", confirmTitle: "Ok") {
            return
        }
    }
}

extension UserViewController: PrivateUsersEventsTableViewCellDelegate {
    func valueChanged(_ value: Bool) {
        presenter?.updateIsPrivateEventsVisible(with: value)
    }
}

extension UserViewController: NotificationAvailabilityTableViewCellDelegate {
    func availabilityChanged(_ value: Bool) {
        presenter?.updateIsNotificationsVisible(with: value)
    }
}

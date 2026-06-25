
import UIKit
import EventKit

class ImportEventViewController: UIViewController {
    
    //MARK: - Naming
    
    var presenter: ImportEventViewOutput?
    
    private lazy var titleLabel = UIElements.eventsTitleLabel
    
    private var events: [SelectableEvent] {
        presenter?.filteredEvents ?? []
    }
    
    private lazy var leadingInset = CGFloat.proportionalToDesignWidth(20)
    
    private lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImportEventTableViewCell.self, forCellReuseIdentifier: ImportEventTableViewCell.identifier)
        tableView.separatorColor = .themeRed.withAlphaComponent(0.2)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var selectLabel: UILabel = {
        let label = UILabel()
        label.text = "Select all"
        label.font = InterFont.medium.of(size: 16)
        label.textColor = .themeRed
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLabelTapped)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.addTarget(
            self,
            action: #selector(handlePopGesture(_:))
        )
        if #available(iOS 18.0, *) {
            tabBarController?.isTabBarHidden = true
        }
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        presenter?.viewDidLoaded()
    }
    
    
    
    //MARK: - Methods
    
    private func setupNavigationItemButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .navigationItemBack, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .navigationItemSave, style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset( CGFloat.proportionalToDesignHeight(73))
            make.leading.equalToSuperview().offset(leadingInset)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(42))
        }
    }
    
    @objc private func leftBarButtonTapped() {
        presenter?.leftBarButtonTapped()
    }
    
    @objc private func saveButtonTapped() {
        presenter?.importEvents()
    }
    
    @objc private func selectLabelTapped() {
        presenter?.selectAll()
    }
    
    @objc private func handlePopGesture(_ gesture: UIGestureRecognizer) {
        guard let navigationController = navigationController, #available(iOS 18.0, *)  else { return }
        if gesture.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if navigationController.topViewController != self {
                    self.tabBarController?.setTabBarHidden(false, animated: true)
                }
            }
        }
    }
}

extension ImportEventViewController: ImportEventViewInput {
    
    func prepareForPermissionRequest(сompletion: () -> Void) {
        setupTitleLabel()
        сompletion()
    }
    
    func showDeniedAlert() {
        setupTitleLabel()
        let alert = UIAlertController(
            title: "Access Needed",
            message: "Countdown needs permission to access your calendar and notifications. Please enable access in Settings to continue.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        let settingsButton = UIAlertAction(title: "Go to Settings", style: .default) { [weak self] _ in
            self?.presenter?.openAppSettings(completion: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsButton)
        
        if self.isViewLoaded && self.view.window != nil {
            self.present(alert, animated: true)
        } else {
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
    func setupCalendarEvents() {
        
        setupNavigationItemButtons()
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Import events"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: InterFont.regular.of(size: 20),
            .foregroundColor: UIColor.blackFont
        ]
        
        titleLabel.removeFromSuperview()
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(selectLabel)
        
        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(leadingInset)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(CGFloat.proportionalToDesignHeight(16))
            make.height.equalTo(52)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(CGFloat.proportionalToDesignHeight(48))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(leadingInset)
            make.bottom.equalToSuperview()
        }
        
        selectLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-leadingInset)
            make.bottom.equalTo(tableView.snp.top).offset(CGFloat.proportionalToDesignHeight(-8))
        }
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showErrorAlert() {
        showAlert(title: "Service Temporarily Unavailable", message: "Please try again later", onConfirm: {})
    }
}

extension ImportEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImportEventTableViewCell.identifier) as? ImportEventTableViewCell else { return UITableViewCell() }
        
        let cellPosition: CellPosition
        
        if indexPath.row == 0, indexPath.row == events.count-1 {
            cellPosition = .single
        } else if indexPath.row == 0 {
            cellPosition = .top
        } else if indexPath.row == events.count-1 {
            cellPosition = .bottom
        } else {
            cellPosition = .middle
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: leadingInset, bottom: 0, right: 0)
        let selectableEvent = events[indexPath.row]
        cell.configure(position: cellPosition, indexPath: indexPath, event: selectableEvent)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        78
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.setNewValue(for: indexPath)
        guard let cell = tableView.cellForRow(at: indexPath) as? ImportEventTableViewCell else { return }
        cell.configure(isSelected: events[indexPath.row].isSelected)
    }
}

extension ImportEventViewController: ImportEventTableViewCellDelegate {
    func setNewValue(for indexPath: IndexPath, with value: Bool) {
        presenter?.setNewValue(for: indexPath)
    }
}

extension ImportEventViewController: CustomSearchBarDelegate {
    func textEntered(_ text: String) {
        presenter?.filterEvents(with: text)
    }
}

extension ImportEventViewController: UIGestureRecognizerDelegate {}

//extension ImportEventViewController: UINavigationControllerDelegate {
//
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            navigationController?.setNavigationBarHidden(false, animated: animated)
//        
//        }
//
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            navigationController?.setNavigationBarHidden(true, animated: animated)
////            if #available(iOS 18.0, *) {
////                tabBarController?.setTabBarHidden(false, animated: animated)
////            }
//        }
//
//        // MARK: - UINavigationControllerDelegate
//        func navigationController(_ navigationController: UINavigationController,
//                                  didShow viewController: UIViewController,
//                                  animated: Bool) {
//            if viewController === self {
//                navigationController.setNavigationBarHidden(false, animated: false)
////                if #available(iOS 18.0, *) {
////                    tabBarController?.setTabBarHidden(true, animated: animated)
////                }
//            }
//        }
//
//        // MARK: - UIGestureRecognizerDelegate
//        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//            return navigationController?.topViewController === self
//        }
//}

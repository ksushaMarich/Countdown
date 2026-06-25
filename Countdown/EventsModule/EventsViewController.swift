
import UIKit
import SnapKit

final class EventsViewController: UIViewController {
    
    // MARK: - Naming
    
    var presenter: EventsViewOutput?
    
    var sortedEvents: SortedEvents = []
    
    private lazy var leadingInset = CGFloat.proportionalToDesignWidth(20)
    
    private lazy var newEventButtonHeight: CGFloat = 46
    
    private lazy var segmentedFont = InterFont.medium.of(size: 16)
    
    private lazy var titleLabel = UIElements.eventsTitleLabel
    
    private lazy var importEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Import from calendar", for: .normal)
        button.setTitleColor(.themeRed, for: .normal)
        button.titleLabel?.font = InterFont.medium.of(size: 16)
        button.titleLabel?.textAlignment = .right
        button.addTarget(self, action: #selector(importEventButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["By date", "By category"])
        segmentedControl.selectedSegmentIndex = EventSortOption.byDate.rawValue
        segmentedControl.selectedSegmentTintColor = .themeRed
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.searchBarBlack,
            .font: segmentedFont
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: segmentedFont
        ], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: EventSectionHeaderView.identifier)
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: newEventButtonHeight, right: 0)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var newEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create a new event", for: .normal)
        button.titleLabel?.font = InterFont.medium.of(size: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .themeRed
        button.addTarget(self, action: #selector(newEventButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewAddGestureRecognizer()
        presenter?.didChangeSortOption(.byDate)
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if #available(iOS 18.0, *) {
            tabBarController?.setTabBarHidden(false, animated: animated)
        }
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        searchBar.text = ""
    }

    // MARK: - Methods
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(importEventButton)
        view.addSubview(searchBar)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(newEventButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset( CGFloat.proportionalToDesignHeight(73))
            make.leading.equalToSuperview().offset(leadingInset)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(42))
        }
        
        importEventButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(CGFloat.proportionalToDesignHeight(15))
            make.trailing.equalToSuperview().offset(-leadingInset)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(20))
        }
        
        searchBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(leadingInset)
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(16))
            make.height.equalTo(52)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(leadingInset)
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(CGFloat.proportionalToDesignHeight(13))
            make.leading.equalTo(segmentedControl.snp.leading)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
        
        newEventButton.snp.makeConstraints { make in
            make.leading.equalTo(leadingInset)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(CGFloat.proportionalToDesignHeight(-16))
            make.height.equalTo(newEventButtonHeight)
        }
    }
    
    private func viewAddGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func importEventButtonTapped() {
        presenter?.importEvent()
    }
    
    @objc private func newEventButtonTapped() {
        presenter?.createEvent()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let option = EventSortOption(rawValue: sender.selectedSegmentIndex) else { return }
        presenter?.didChangeSortOption(option)
    }
}

extension EventsViewController: EventsViewInput {
    
    func update(with events: SortedEvents) {
        self.sortedEvents = events
        tableView.reloadData()
    }
    
    func showErrorAlert() {
        showAlert(title: "Service Temporarily Unavailable", message: "Please try again later", onConfirm: {})
    }
    
    func reloadTabelView() {
        tableView.reloadData()
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sortedEvents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedEvents[section].events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        102
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as? EventTableViewCell else {
            return UITableViewCell()
        }
        let events = sortedEvents[indexPath.section].events
        let position: CellPosition
        if events.count == 1 {
            position = .single
        } else if indexPath.row == 0 {
            position = .top
        } else if indexPath.row == events.count - 1 {
            position = .bottom
        } else {
            position = .middle
        }
        
        cell.configure(with: events[indexPath.row], for: indexPath, position: position)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventSectionHeaderView.identifier) as? EventSectionHeaderView else {
                return nil
            }
        
        header.configure(with: sortedEvents[section].month)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.proportionalToDesignHeight(37)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
	}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.tableViewDidSelectRowAt(indexPath)
    }
}

extension EventsViewController: EventTableViewCellDelegate {
    
    func deleteCell(with event: Event) {
        showAlert(title: "Delete Event", message: "Are you sure you want to delete this event? This action cannot be undone.", confirmTitle: "Delete", cancelTitle: "Cancel") { [weak self] in
               self?.presenter?.deleteEvent(event)
        }
    }
    
    func deleteViewIsViewOpened(for indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            if let eventCell = cell as? EventTableViewCell, eventCell.indexPath != indexPath, eventCell.isDeleteViewOpened {
                eventCell.closeDeleteView()
            }
        }
    }
}

extension EventsViewController: CustomSearchBarDelegate {
    func textEntered(_ text: String) {
        presenter?.filterEvents(with: text)
    }
}

extension EventsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


import UIKit
import SnapKit

final class NewEventViewController: UIViewController {
    
    //MARK: - Naming
    
    var presenter: NewEventViewOutput?
    
    private var choiceRepeatTableViewInitialY: CGFloat?
    
    private var initialContentOffsetY: CGFloat?
    
    private var dropdownTableView: DropdownTablelView?
    
    private var isKeyboardVisible = false
    
    private var originalContentOffset: CGPoint?
    
    private var isCategoryImported: Bool = false
    
    private var сalendarTableViewCellheight: CGFloat = 500
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewEventNameTableViewCell.self, forCellReuseIdentifier: NewEventNameTableViewCell.identifier)
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.register(ChoosingTimeTableViewCell.self, forCellReuseIdentifier: ChoosingTimeTableViewCell.identifier)
        tableView.register(RepeatTableViewCell.self, forCellReuseIdentifier: RepeatTableViewCell.identifier)
        tableView.register(EventAlertTableViewCell.self, forCellReuseIdentifier: EventAlertTableViewCell.identifier)
        tableView.register(EventCategoryTableViewCell.self, forCellReuseIdentifier: EventCategoryTableViewCell.identifier)
        tableView.register(WidgetTableViewCell.self, forCellReuseIdentifier: WidgetTableViewCell.identifier)
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 41, right: 0)
        tableView.tag = 1
        return tableView
    }()
    
    private var hideKeyboardTapRecognizer: UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideOverlays))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        return tapGestureRecognizer
    }
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setupView()
        addGestureRecognizers()
        setupNavigationItemAppearance()
        setupNavigationItemButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = presenter?.eventToEdit != nil ? "Event" : "Schedule a new event"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: InterFont.regular.of(size: 20),
            .foregroundColor: UIColor.blackFont
        ]
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.addTarget(
            self,
            action: #selector(handlePopGesture(_:))
        )
        if #available(iOS 18.0, *) {
            tabBarController?.isTabBarHidden = true
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Methods
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.bottom.equalTo(CGFloat.proportionalToDesignHeight(41))
        }
    }
    
    private func addGestureRecognizers() {
        
//        view.addGestureRecognizer(hideKeyboardTapRecognizer)
        tableView.addGestureRecognizer(hideKeyboardTapRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func setupNavigationItemAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    private func setupNavigationItemButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .navigationItemBack, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .navigationItemSave, style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func hideOverlays() {
        
        if isKeyboardVisible {
            guard let originalContentOffset else { return }
            tableView.setContentOffset(originalContentOffset, animated: true)
            isKeyboardVisible = false
            view.endEditing(true)
        }
        
        if let dropdownTableView {
            dropdownTableView.delegate = nil
            dropdownTableView.snp.removeConstraints()
            dropdownTableView.removeFromSuperview()
            presenter?.dropdownIsClosed()
        }
    }
    
    @objc private func leftBarButtonTapped() {
        presenter?.leftBarButtonTapped()
    }
    
    @objc private func saveButtonTapped() {
        presenter?.saveButtonTapped()
    }
    
    @objc private func keyboardDidShow() {
        isKeyboardVisible = true
    }
    
    @objc private func handlePopGesture(_ gesture: UIGestureRecognizer) {
        guard let navigationController = navigationController, #available(iOS 18.0, *)  else { return }
        if gesture.state == .ended {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if navigationController.topViewController != self, !(navigationController.topViewController is GreetingViewController) {
                    self.tabBarController?.setTabBarHidden(false, animated: true)
                }
            }
        }
    }
}

extension NewEventViewController: NewEventViewInput {
    
    func updateEventInfo() {
        tableView.beginUpdates()
        tableView.endUpdates()
        guard  let event = presenter?.event else { return }
        
        if let widgetCell = tableView.cellForRow(at: IndexPath(row: 0, section: 7)) as? WidgetTableViewCell {
            widgetCell.configure(with: event)
        }
        
        if let timeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ChoosingTimeTableViewCell, let date = Date.makeDateForEvent(event) {
            timeCell.manageHintDisplay(for: date)
        }
    }
    
    func openDropdownTableView(newDropdownTableView: DropdownTablelView, indexPath: IndexPath) {
        
        newDropdownTableView.dropdownDelegate = self
        
        dropdownTableView = newDropdownTableView
        
        guard let dropdownTableView, let size = presenter?.getDropdownTableViewSize() else { return }
        
        view.addSubview(dropdownTableView)
        
        view.layoutIfNeeded()
        
        let cellRect = tableView.rectForRow(at: indexPath)
        let convertedRect = tableView.convert(cellRect, to: view)

        choiceRepeatTableViewInitialY = convertedRect.maxY + 4
        initialContentOffsetY = self.tableView.contentOffset.y
        
        if let choiceRepeatTableViewInitialY {
            dropdownTableView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(choiceRepeatTableViewInitialY)
                make.trailing.equalTo(tableView.snp.trailing).offset(6)
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
    }
    
    func closeDropdownTableView() {
        hideOverlays()
    }
    
    func configureEventCategoryTableViewCell(with category: String, color: UIColor?) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? EventCategoryTableViewCell else { return }
        cell.configure(with: category, color: color)
    }
}

extension NewEventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewEventNameTableViewCell.identifier) as? NewEventNameTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(name: presenter?.event.name)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as? NoteTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(with: presenter?.event.note ?? "")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier) as? CalendarTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            if let presenter, let daysLeft = presenter.event.daysLeft {
                cell.setDaysLeftLabelText(with: daysLeft)
                cell.configure(with: presenter.event.date)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.сalendarTableViewCellheight = cell.getCellHeight()
            }
            return cell
        
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChoosingTimeTableViewCell.identifier) as? ChoosingTimeTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(time: presenter?.event.time)
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.identifier) as? RepeatTableViewCell else { return UITableViewCell() }
            if let repeatOption = presenter?.event.repeatOption {
                cell.configure(with: repeatOption)
            }
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventAlertTableViewCell.identifier) as? EventAlertTableViewCell else { return UITableViewCell() }
            if let alertOption = presenter?.event.alertOption {
                cell.configure(with: alertOption)
            }
            return cell
            
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCategoryTableViewCell.identifier) as? EventCategoryTableViewCell else { return UITableViewCell() }
            if let categoryOption = presenter?.event.category, let colors = EventOptionsType.category.getColors(), let index =
                EventOptionsType.category.getOptions().firstIndex(where: { $0 == categoryOption }) {
                cell.configure(with: categoryOption, color: colors[index] )
            } else {
                isCategoryImported = true
                cell.configure(with: "Imported", color: .black )
            }
            return cell
            
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WidgetTableViewCell.identifier) as? WidgetTableViewCell else { return UITableViewCell() }
            if let event = presenter?.event {
                cell.configure(with: event)
            }
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 5 {
            return isCategoryImported ? nil : indexPath
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.isUserInteractionEnabled = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let baseHeight: CGFloat = 52
        
        switch indexPath.section {
        case 1:
            return max(baseHeight * 3, presenter?.textViewHeight ?? 0)
        case 2:
            return сalendarTableViewCellheight
        case 3:
            guard let isTimeModeOn = presenter?.isTimeMode else { return baseHeight }
            return isTimeModeOn ? 122 : baseHeight
            
        case 7:
            return CGFloat.proportionalToDesignHeight(652)
        default:
            return baseHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.tableViewDidSelectRowAt(indexPath: indexPath)
    }
}

extension NewEventViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else { return true }
        
        if touchedView is UITableViewCell || touchedView.superview is UITableViewCell || touchedView.superview?.superview is UITableViewCell {
            return false
        }

        return true
    }
}

extension NewEventViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isKeyboardVisible {
            isKeyboardVisible = false
            view.endEditing(true)
        }
        
        guard
            scrollView.tag == 1, let dropdownTableView, let type = presenter?.openedDropdownType,
            view.subviews.contains(dropdownTableView)
        else { return }
        
        let cellRect: CGRect
        
        switch type {
        case .repeatEvent:
            cellRect = tableView.rectForRow(at: IndexPath(row: 0, section: 4))
        case .alert:
            cellRect = tableView.rectForRow(at: IndexPath(row: 0, section: 5))
        case .category:
            cellRect = tableView.rectForRow(at: IndexPath(row: 0, section: 6))
        }

        let convertedRect = tableView.convert(cellRect, to: view)

        dropdownTableView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(convertedRect.maxY + 4)
        }
    }
}

extension NewEventViewController: NewEventNameTableViewCellDelegate {
    func eventNameСhanged(_ newName: String) {
        presenter?.nameChanged(newName)
    }
}

extension NewEventViewController: CalendarTableViewCellDelegate {
    func dateСhanged(_ newData: Date?) {
        presenter?.dateСhanged(newData)
    }
}

extension NewEventViewController: ChoosingTimeTableViewCellDelegate {
    func timeTextFieldIsSelected() {
        originalContentOffset = tableView.contentOffset
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) {
            tableView.setContentOffset(CGPoint(x: 0, y: 300 + cell.frame.height), animated: true)
        }
    }
    
    func modeDidChange(isTimeModeOn: Bool) {
        presenter?.timeModeIsChanged(isTimeModeOn)
    }
    
    func timeDidChange(hours: Int, minutes: Int) {
        presenter?.timeDidChange(hours: hours, minutes: minutes)
    }
}

extension NewEventViewController: WidgetTableViewCellDelegate {
    
    func addWidget() {
        saveButtonTapped()
    }
    
    func upgradeToPro() {
        print("upgradeToPro tapped.")
    }
    
    func newWidgetBackgroundStateIsSelected(_ state: WidgetBackgroundState) {
        presenter?.widgetBackgroundStateIsChanged(state)
    }
    
    func presentPaywall() {
        presenter?.presentPaywall()
    }
}

extension NewEventViewController: DropdownTablelViewDelegate {
    
    func newOptionIsSelected(for type: EventOptionsType, at index: Int) {
        
        switch type {
        case .repeatEvent:
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? RepeatTableViewCell else { return }
            cell.configure(with: type.getOptions()[index])
        case .alert:
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? EventAlertTableViewCell else { return }
            cell.configure(with: type.getOptions()[index])
        case .category:
            let options = type.getOptions()
            if options.count == index {
                hideOverlays()
                return
            }
            configureEventCategoryTableViewCell(with: options[index], color: type.getColors()?[index])
        }
        presenter?.setOptionSelected(for: type, index: index)
        hideOverlays()
    }
    
    func addNewCategory() {
        presenter?.addCategoryTapped()
    }
}

extension NewEventViewController: NoteTableViewCellDelegate {
    func newRequiredHeight(_ height: CGFloat) {
        presenter?.updateTextViewHeight(with: height + 10)
        UIView.performWithoutAnimation {
        tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func textDidChange(with text: String) {
        presenter?.noteDidChange(with: text)
    }
}

extension NewEventViewController: UINavigationControllerDelegate {}


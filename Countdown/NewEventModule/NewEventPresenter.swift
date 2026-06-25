
import Foundation
import WidgetKit
import UIKit

protocol NewEventViewInput: AnyObject {
    var presenter: NewEventViewOutput? { get set }
    func updateEventInfo()
    func openDropdownTableView(newDropdownTableView: DropdownTablelView, indexPath: IndexPath)
    func closeDropdownTableView()
    func configureEventCategoryTableViewCell(with category: String, color: UIColor?)
}

protocol NewEventViewOutput: AnyObject {
    var view: NewEventViewInput? { get set }
    var isTimeMode: Bool { get }
    var event: Event { get }
    var eventToEdit: Event? { get }
    var openedDropdownType: EventOptionsType? { get }
    var textViewHeight: CGFloat { get }
    func nameChanged(_ newName: String)
    func dateСhanged(_ newData: Date?)
    func timeModeIsChanged(_ isTimeMode: Bool)
    func timeDidChange(hours: Int, minutes: Int)
    func widgetBackgroundStateIsChanged(_ state: WidgetBackgroundState)
    func leftBarButtonTapped()
    func saveButtonTapped()
    func tableViewDidSelectRowAt(indexPath: IndexPath)
    func setDropdownTableViewOpen(for type: EventOptionsType?)
    func dropdownIsClosed()
    func setOptionSelected(for type: EventOptionsType, index: Int)
    func getDropdownTableViewSize() -> EventOptionsSize
    func addCategoryTapped()
    func updateTextViewHeight(with height: CGFloat)
    func noteDidChange(with text: String)
    func presentPaywall()
    func updateEventToEdit(_ event: Event)
}

class NewEventPresenter {
    
    //MARK: - Naming
    
    weak var view: NewEventViewInput?
    
    var router: NewEventModuleRouterProtocol?
    
    private let currentDate = Date()
    
    private let currentCalendar = Calendar.current
    
    private(set) var eventToEdit: Event?
    
    private let eventOptionsType = EventOptionsType.self
    
    private var subscriptionsService = SubscriptionsService.shared
    
    private(set) var textViewHeight: CGFloat = 0
    
    internal lazy var event = Event(name: "", date: currentDate, note: "", category: eventOptionsType.category.getOptions()[0], repeatOption: EventOptionsType.repeatEvent.getOptions()[0], alertOption: eventOptionsType.alert.getOptions()[0], widgetBackgroundState: WidgetBackgroundState(colorIndex: 0, imageIndex: 0), id: nil) {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateEventInfo()
            }
        }
    }
    
    private(set) lazy var isTimeMode: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateEventInfo()
            }
        }
    }
    
    //MARK: - Option Dropdown
    
    private(set) var openedDropdownType: EventOptionsType?
    
    private(set) var selectedRepeatOptionIndex: Int {
        get {
            guard let index = EventOptionsType.repeatEvent.getOptions().firstIndex(where: { $0 == event.repeatOption }) else {
                return 0
            }
            return index
        }
        set {
            event.repeatOption = EventOptionsType.repeatEvent.getOptions()[newValue]
        }
    }

    private(set) var selectedAlertOptionIndex: Int {
        get {
            guard let index = EventOptionsType.alert.getOptions().firstIndex(where: { $0 == event.alertOption }) else {
                return 0
            }
            return index
        }
        set {
            event.alertOption = EventOptionsType.alert.getOptions()[newValue]
        }
    }
    
    private(set) var selectedCategoryOptionIndex: Int {
        get {
            guard let index = EventOptionsType.category.getOptions().firstIndex(where: { $0 == event.category }) else {
                return 0
            }
            return index
        }
        set {
            event.category = EventOptionsType.category.getOptions()[newValue]
        }
    }
    
    //MARK: - Life cycle
    
    init(event: Event?) {
        eventToEdit = event
        if let eventToEdit {
            self.event = eventToEdit
            isTimeMode = self.event.time != nil
        }
    }
    
    //MARK: - Methods
    
    private func openedDropdown(with type: EventOptionsType?, at indexPath: IndexPath) {
        guard let type else {
            view?.closeDropdownTableView()
            return
        }
        
        if openedDropdownType == type {
            view?.closeDropdownTableView()
        } else {
            view?.closeDropdownTableView()
            self.openedDropdownType = type
            view?.openDropdownTableView(newDropdownTableView: DropdownTablelView(frame: .zero, type: type, selectedIndex: getOptionIndex(for: type)), indexPath: indexPath)
        }
    }
    
    private func getOptionIndex(for type: EventOptionsType) -> Int {
        switch type {
        case .repeatEvent:
            return selectedRepeatOptionIndex
        case .alert:
            return selectedAlertOptionIndex
        case .category:
            return selectedCategoryOptionIndex
        }
    }
    
    private func saveEvent() {
        CoreDataManager.shared.saveEvent(event) { [weak self] result in
            self?.addNotification()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success:
                    if let id = event.id?.uuidString {
                        RepeatOptionsStore.shared.save(
                            RepeatOptionModel(id: id, repeatOption: event.repeatOption)
                        )
                    }
                    router?.pushEventsViewController()
                case .failure:
                    router?.showErrorAlert()
                }
            }
        }
    }
    
    private func addNotification() {
        guard let id = event.id, let date = Date.makeDateForEvent(event) else { return }
        let notificationService = NotificationService.shared
        if let eventToEdit, let eventToEditId = eventToEdit.id {
            notificationService.removeNotification(with: eventToEditId.uuidString)
        }
        notificationService.scheduleNotification(id: id.uuidString, body: event.name == "" ? "New event" : event.name, date: date, isPrivate: event.isPrivate, alertOption: event.alertOption)
    }
}

extension NewEventPresenter: NewEventViewOutput {
    
    func widgetBackgroundStateIsChanged(_ state: WidgetBackgroundState) {
        event.widgetBackgroundState = state
    }
    
    func nameChanged(_ newName: String) {
        event.name = newName
    }
    
    func dateСhanged(_ newData: Date?) {
        guard let newData else { return }
        event.date = newData
    }
    
    func timeModeIsChanged(_ isTimeMode: Bool) {
        guard isTimeMode != self.isTimeMode else { return }
        self.isTimeMode = isTimeMode
        
        if isTimeMode == true {
            event.time = EventTime(hour: 0, minute: 0)
        } else {
            event.time = nil
        }
    }
    
    func timeDidChange(hours: Int, minutes: Int) {
        event.time = EventTime(hour: hours, minute: minutes)
    }
    
    func leftBarButtonTapped() {
        router?.popViewController()
    }
    
    func presentPaywall() {
        router?.presentPaywall()
    }
    
    func saveButtonTapped() {
        
        if let date = Date.makeDateForEvent(event), date > Date() {
            
            CoreDataManager.shared.fetchEvents { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let events):
                    
                    if events.count >= 1, eventToEdit == nil, !subscriptionsService.hasSubscription {
                        router?.presentPaywall()
                    } else {
                        
                        let coreDataManager = CoreDataManager.shared
                        
                        if event.name == "" {
                            event.name = "New Event"
                        }
                        
                        if let eventToEdit {
                            if let widgetId = event.id {
                                AppGroupEventService.shared.updateEvent(id: widgetId.uuidString, name: event.name, dateOfEvent: date, image: event.widgetBackgroundState.imageIndex, colors: event.widgetBackgroundState.colorIndex, isPrivate: event.category == "Private event")
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                            
                            coreDataManager.deleteEvent(eventToEdit) { [weak self] result in
                                guard let self else { return }
                                switch result {
                                case .success:
                                    saveEvent()
                                case .failure:
                                    router?.showErrorAlert()
                                }
                            }
                            
                        } else {
                            let id = UUID()
                            event.id = id
                            if let combinedDate = Date.makeDateForEvent(event), let eventId = event.id?.uuidString {
                                AppGroupEventService.shared.addEvent(AppGroupEvent(id: eventId, name: self.event.name == "" ? "New Event" : self.event.name, dateOfEvent: combinedDate, image: event.widgetBackgroundState.imageIndex, colors: event.widgetBackgroundState.colorIndex, isPrivate: event.category == "Private event"))
                            }
                            saveEvent()
                        }
                    }
                    
                case .failure(_):
                    router?.showErrorAlert()
                }
            }
        } else {
            print("Error, Invalid date!")
        }
	}
    
    func tableViewDidSelectRowAt(indexPath: IndexPath){
        let type: EventOptionsType?
        
        switch indexPath.section {
        case 4:
            type = .repeatEvent
        case 5:
            type = .alert
        case 6:
            type = .category
        default:
            type = nil
        }
        
        openedDropdown(with: type, at: indexPath)
    }
    
    //MARK: - Option Dropdown
    
    func setDropdownTableViewOpen(for type: EventOptionsType?) {
        openedDropdownType = type
    }
    
    func dropdownIsClosed() {
        openedDropdownType = nil
    }
    
    func setOptionSelected(for type: EventOptionsType, index: Int) {
        switch type {
        case .repeatEvent:
            selectedRepeatOptionIndex = index
        case .alert:
            selectedAlertOptionIndex = index
        case .category:
            selectedCategoryOptionIndex = index
        }
    }
    
    func getDropdownTableViewSize() -> EventOptionsSize {
        guard let openedDropdownType else { return EventOptionsSize(width: 0, height: 0) }
        return EventOptionsSize.getSize(for: openedDropdownType)
    }
    
    func addCategoryTapped() {
        guard let viewController = view as? UIViewController else { return }
        router?.presentCustomCategoryModule(safeAreaTopHeight: viewController.view.safeAreaInsets.top) { category in
            guard let index = EventOptionsType.category.getOptions().firstIndex(where: { $0 == category.name}) else { return }
            self.setOptionSelected(for: .category, index: index)
            self.view?.configureEventCategoryTableViewCell(with: category.name, color: EventOptionsType.category.getColors()?[index])
            self.event.category = category.name
        }
    }
    
    func updateTextViewHeight(with height: CGFloat) {
        textViewHeight = height
    }
    
    func noteDidChange(with text: String) {
        event.note = text
    }
    
    func updateEventToEdit(_ event: Event) {
        eventToEdit = event
    }
}


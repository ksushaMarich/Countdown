import CloudKit
import UIKit
import EventKit


protocol ImportEventViewInput: AnyObject {
    var presenter: ImportEventViewOutput? { get set }
    func prepareForPermissionRequest(сompletion: () -> Void)
    func showDeniedAlert()
    func setupCalendarEvents()
    func reloadTableView()
    func showErrorAlert()
}

protocol ImportEventViewOutput: AnyObject {
    var view: ImportEventViewInput? { get set }
    var filteredEvents: [SelectableEvent] { get }
    func selectAll()
    func setNewValue(for indexPath: IndexPath)
    func viewDidLoaded()
    func filterEvents(with text: String)
    func leftBarButtonTapped()
    func openAppSettings(completion: ((Bool) -> Void)?)
    func importEvents()
}

class ImportEventPresenter {
    weak var view: ImportEventViewInput?
    var router: ImportEventModuleRouterProtocol?
    
    private var allEvents: [SelectableEvent] = []
    
    private(set) var filteredEvents: [SelectableEvent] = []
    
    private var importedEvents: [Event] = []
    
    private var isAllSelected: Bool = false
    
    private func isEventImported(event: EKEvent) -> Bool {
        importedEvents.contains(where: { importedEvent in
            event.eventIdentifier == importedEvent.calendarItemIdentifier &&
            event.title == importedEvent.name &&
            event.startDate == importedEvent.date
        })
    }
    
    private var subscriptionsService = SubscriptionsService.shared
    
    private func setupViewWithEvents() {
        view?.setupCalendarEvents()
        CoreDataManager.shared.fetchEvents { [weak self] result  in
            switch result {
            case .success(let events):
                self?.importedEvents = events
            case .failure(_):
                self?.view?.showErrorAlert()
            }
            
            CalendarPermissionService.shared.fetchAllFutureEvents { [weak self] events in
                guard let self else { return }
                for event in events {
                    if !isEventImported(event: event) {
                        self.allEvents.append(SelectableEvent(event: event, isSelected: false))
                    } else {
                        self.allEvents.append(SelectableEvent(event: event, isSelected: true))
                    }
                }
                self.filteredEvents = self.allEvents
                view?.reloadTableView()
            }
        }
    }
    
    private func prepareForPermissionRequest() {
        view?.prepareForPermissionRequest(сompletion: {
            let eventStore = EKEventStore()

            if #available(iOS 17.0, *) {
                eventStore.requestFullAccessToEvents { granted, error in
                    DispatchQueue.main.async {
                        if granted {
                            self.setupViewWithEvents()
                        } else {
                            self.router?.popViewController()
                        }
                    }
                }
            } else {
                eventStore.requestAccess(to: .event) { granted, _ in
                    DispatchQueue.main.async {
                        if granted {
                            self.setupViewWithEvents()
                        } else {
                            self.router?.popViewController()
                        }
                    }
                }
            }
        })
    }
}

extension ImportEventPresenter: ImportEventViewOutput {
    
    func viewDidLoaded() {
        
        CalendarPermissionService.shared.checkPermission { [weak self] status in
            guard let self else { return }
            switch status {
            case .authorized:
                setupViewWithEvents()
            case .denied:
                view?.showDeniedAlert()
            case .notDetermined:
                prepareForPermissionRequest()
            }
        }
    }
    
    func leftBarButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.router?.popViewController()
        }
    }
    
    func setNewValue(for indexPath: IndexPath) {
        filteredEvents[indexPath.row].isSelected = !filteredEvents[indexPath.row].isSelected
    }
    
    func checkIsAllSelected() -> Bool {
        return filteredEvents.map { $0.isSelected }.contains(false) ? false : true
    }
    
    func selectAll() {
        let value: Bool = checkIsAllSelected() ? false : true
        for i in 0..<self.filteredEvents.count {
            self.filteredEvents[i].isSelected = value
        }
        view?.reloadTableView()
    }
    
    func filterEvents(with text: String) {
        guard text != "" else {
            filteredEvents = allEvents
            view?.reloadTableView()
            return
        }
        filteredEvents = allEvents.filter { $0.event.title.lowercased().contains(text.lowercased()) }
        view?.reloadTableView()
    }
    
    func openAppSettings(completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            completion?(false)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func importEvents() {
        guard subscriptionsService.hasSubscription else {
            router?.presentPaywall()
            return
        }
        
        for selectableEvent in self.filteredEvents {
            let event = selectableEvent.event
            let date: Date = event.startDate
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            
            guard let hour = components.hour, let minute = components.minute else { return }
            
            if selectableEvent.isSelected, !isEventImported(event: selectableEvent.event) {
                
                CoreDataManager.shared.saveEvent(Event(name: event.title, date: date, note: "", time: EventTime(hour: hour, minute: minute), category: "Imported", repeatOption: EventOptionsType.repeatEvent.getOptions()[0], alertOption: EventOptionsType.alert.getOptions()[0], widgetBackgroundState: WidgetBackgroundState(colorIndex: 0, imageIndex: 0), isAllDay: event.isAllDay, calendarItemIdentifier: event.eventIdentifier, id: nil)) { _ in }
            } else if !selectableEvent.isSelected {
                
                CoreDataManager.shared.deleteEvent(Event(name: event.title, date: date, note: "", time: EventTime(hour: hour, minute: minute), category: "Imported", repeatOption: EventOptionsType.repeatEvent.getOptions()[0], alertOption: EventOptionsType.alert.getOptions()[0], widgetBackgroundState: WidgetBackgroundState(colorIndex: 0, imageIndex: 0), isAllDay: event.isAllDay, calendarItemIdentifier: event.eventIdentifier, id: nil)) { _ in }
            }
        }
        router?.navigateToNextScreen()
    }
}




import Foundation
import UIKit

protocol EventsViewInput: AnyObject {
    var presenter: EventsViewOutput? { get set }
    var sortedEvents: SortedEvents { get set}
    func update(with events: SortedEvents)
    func showErrorAlert()
    func reloadTabelView()
}

protocol EventsViewOutput: AnyObject {
    var view: EventsViewInput? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didChangeSortOption(_ value: EventSortOption)
    func deleteEvent(_ event: Event)
    func importEvent()
    func createEvent()
	func filterEvents(with text: String)
    func tableViewDidSelectRowAt(_ indexPath: IndexPath)
}

final class EventsPresenter {
    
    //MARK: - Naming
    
    weak var view: EventsViewInput?
    var router: EventsModuleRouterProtocol?
    private let eventId: String?
    
    private var events: [Event] = []
    private var sortedEvents: SortedEvents = []
    private var sortOption: EventSortOption = .byDate
    
    private var subscriptionsService = SubscriptionsService.shared
    
    private var isPrivateEventsVisible: Bool {
        PrivateEventsVisibilityManager.shared.isPrivateEventsVisible
    }
    
    //MARK: - Life cycle
    
    init(eventId: String?) {
        self.eventId = eventId
    }
    
    //MARK: - Methods
    
    private func sortEventsByDate() {
        var dateEventDict: [Date: [Event]] = [:]
        let calendar = Calendar.current

        for event in events {
            let components = calendar.dateComponents([.year, .month], from: event.date)
            if let normalizedDate = calendar.date(from: components), isPrivateEventsVisible || event.isPrivate {
                dateEventDict[normalizedDate, default: []].append(event)
            }
        }
        
        var grouped: [(date: Date, events: [Event])] = []

        for (date, events) in dateEventDict {
            let sorted = events.sorted { $0.date < $1.date }
            grouped.append((date, sorted))
        }

        grouped.sort { $0.date < $1.date }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US")
        outputFormatter.dateFormat = "MMMM yyyy"

        let result: SortedEvents = grouped.map { (date, events) in
            let prettyKey = outputFormatter.string(from: date)
            return (prettyKey, events)
        }

        sortedEvents = result
    }
    
    private func sortEventsByCategory() {
        var grouped: [String: [Event]] = [:]
        
        for event in events {
            if isPrivateEventsVisible || event.isPrivate {
                grouped[event.category, default: []].append(event)
            }
        }
        
        let result: SortedEvents = grouped.map { key, events in
            let sortedEvents = events.sorted {
                return $0.date < $1.date
            }
            return (key, sortedEvents)
        }
        
        sortedEvents = result
    }
    
    private func deleteWidget(for id: UUID) {
        AppGroupEventService.shared.removeEvent(id: id)
    }
    
    private func deleteNotification(for id: UUID) {
        NotificationService.shared.removeNotification(with: id.uuidString)
    }
    
    private var timer: Timer?
    
    func startMonitoring() {
           
           timer?.invalidate()
           timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
               self.checkEvents()
           }
       }
       
       func stopMonitoring() {
           timer?.invalidate()
           timer = nil
       }
       
       private func checkEvents() {
           let now = Date()
           
           var occurredEvents: [Event] = []
           
           for event in events {
               if let date = Date.makeDateForEvent(event), date <= now {
                   occurredEvents.append(event)
               }
           }
           
           guard !occurredEvents.isEmpty else { return }
           
           if self.events.count == 1, !subscriptionsService.hasSubscription {
               router?.presentSubscriptionReminderViewController()
           }
           
           CoreDataManager.shared.fetchEvents { [weak self] results in
               guard let self else { return }
               
               switch results {
               case .success(let events):
                   self.events = events
                   
                   if events.count == 0 {
                       router?.navigateToGreetingModule()
                       return
                   }
                   
                   switch sortOption {
                   case .byDate:
                       self.sortEventsByDate()
                   case .byCategory:
                       self.sortEventsByCategory()
                   }
                   view?.update(with: sortedEvents)
                   
               case .failure(_):
                   if let viewController = view as? UIViewController {
                       viewController.showAlert(title: "Service Temporarily Unavailable", message: "Please try again later") {}
                   }
               }
           }
       }
}

extension EventsPresenter: EventsViewOutput {
    
    func viewDidLoad() {
        
        CoreDataManager.shared.fetchEvents { [weak self] results in
            guard let self else { return }
            
            switch results {
            case .success(let events):
                self.events = events
                sortEventsByDate()
                view?.update(with: sortedEvents)
                
                if self.events.map({ $0.id?.uuidString }).contains(self.eventId), let urlEvent = events.first(where: { $0.id?.uuidString == self.eventId}) {
                    router?.navigateToNewEventModule(with: urlEvent)
                    return
                }
                
                if events.count >= 1, !subscriptionsService.hasSubscription {
                    router?.presentSubscriptionReminderViewController()
                }
            case .failure(_):
                if let viewController = view as? UIViewController {
                    viewController.showAlert(title: "Service Temporarily Unavailable", message: "Please try again later") {}
                }
            }
        }
    }
    
    func viewWillAppear() {
        CoreDataManager.shared.fetchEvents { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let events):
                if events.count == 0 {
                    router?.navigateToGreetingModule()
                    return
                }
                self.events = events
                startMonitoring()
            case .failure:
                view?.showErrorAlert()
            }
            
            switch sortOption {
            case .byDate:
                self.sortEventsByDate()
            case .byCategory:
                self.sortEventsByCategory()
            }
            
            view?.update(with: sortedEvents)
        }
    }
    
    func viewWillDisappear() {
        stopMonitoring()
    }
    
    func didChangeSortOption(_ value: EventSortOption) {
        sortOption = value
        switch value {
        case .byDate:
            sortEventsByDate()
            view?.update(with: sortedEvents)
        case .byCategory:
            sortEventsByCategory()
            view?.update(with: sortedEvents)
        }
    }
    
    func deleteEvent(_ event: Event) {
        
        for index in sortedEvents.indices.reversed() {
            sortedEvents[index].events.removeAll { $0 == event }
            
            if sortedEvents[index].events.isEmpty {
                sortedEvents.remove(at: index)
            }
        }
        
        if let id = event.id {
            deleteWidget(for: id)
            deleteNotification(for: id)
        }
        
        CoreDataManager.shared.deleteEvent(event) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.events.removeAll { $0 == event }
                    if self.sortedEvents.isEmpty {
                        self.router?.navigateToGreetingModule()
                    } else {
                        self.view?.update(with: self.sortedEvents)
                    }
                }
            case .failure:
                router?.showErrorAlert()
            }
        }
    }
    
    func importEvent() {
        router?.navigateToImportEventModule()
    }
    
    func createEvent() {
        router?.navigateToNewEventModule()
    }
    
    func tableViewDidSelectRowAt(_ indexPath: IndexPath) {
        router?.navigateToNewEventModule(with: sortedEvents[indexPath.section].events[indexPath.row])
	}

    func filterEvents(with text: String) {
        if text == "" {
            view?.update(with: sortedEvents)
        } else {
            let eventsFilteredByName = sortedEvents.map { eventGroup in
                var group = eventGroup
                group.events.removeAll { !$0.name.lowercased().contains(text.lowercased()) }
                return group
            }
            
            view?.update(with: eventsFilteredByName.filter { !$0.events.isEmpty })
      }
    }
}

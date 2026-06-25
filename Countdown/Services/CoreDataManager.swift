
import UIKit
import CoreData
import EventKit

public final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let saveQueue = DispatchQueue(label: "com.yourapp.saveQueue", qos: .userInitiated)
    
    private var context: NSManagedObjectContext {
        eventContainer.viewContext
    }
    
    private func hasSameDayInNextMonth(for date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: date) else {
            return false
        }
        
        let components = calendar.dateComponents([.year, .month], from: nextMonthDate)
        guard let _ = components.year,
              let _ = components.month,
              let range = calendar.range(of: .day, in: .month, for: nextMonthDate) else {
            return false
        }
        
        let daysInNextMonth = Array(range)
        
        return daysInNextMonth.contains(day)
    }
    
    private func updateEventsIfExpired(_ eventsForUpdate: [Event]) -> [Event] {
        var events = eventsForUpdate
        let calendar = Calendar.current
        let appGroupEventService = AppGroupEventService.shared
        
        for i in events.indices.reversed() {
            if let realDate = Date.makeDateForEvent(events[i]), realDate < Date() {
                var event = events[i]
                self.deleteEvent(event) { _ in }
                
                switch event.repeatOption {
                    
                case RepeatOption.everyDay.rawValue:
                    event.date = calendar.date(byAdding: .day, value: 1, to: events[i].date) ?? events[i].date
                    self.saveEvent(event) { _ in}
                    events.append(event)
                    
                case RepeatOption.everyWeek.rawValue:
                    event.date = calendar.date(byAdding: .day, value: 7, to: events[i].date) ?? events[i].date
                    self.saveEvent(event) { _ in}
                    events.append(event)
                    
                case RepeatOption.everyTwoWeeks.rawValue:
                    event.date = calendar.date(byAdding: .day, value: 14, to: events[i].date) ?? events[i].date
                    self.saveEvent(event) { _ in}
                    events.append(event)
                    
                case RepeatOption.everyMonth.rawValue:
                    if hasSameDayInNextMonth(for: event.date) {
                        event.date = calendar.date(byAdding: .month, value: 1, to: events[i].date) ?? events[i].date
                        self.saveEvent(event) { _ in}
                        events.append(event)
                    }
                    
                case RepeatOption.everyYear.rawValue:
                    event.date = calendar.date(byAdding: .year, value: 1, to: events[i].date) ?? events[i].date
                    self.saveEvent(event) { _ in}
                    events.append(event)
                    
                default:
                    guard let id = event.id else { continue }
                    appGroupEventService.removeEvent(id: id)
                }
                
                if let id = event.id?.uuidString {
                    appGroupEventService.updateEvent(id: id, name: event.name, dateOfEvent: event.date, image: event.widgetBackgroundState.imageIndex, colors: event.widgetBackgroundState.colorIndex, isPrivate: event.isPrivate)
                }
                
                events.remove(at: i)
            }
        }
        
        return events
    }
    
    private func makeUniqueEvents(for events: [Event]) -> [Event] {
        
        var uniqueEvents: [Event] = []
        
        for event in events {
            if !uniqueEvents.contains(where: { $0.id == event.id}) {
                uniqueEvents.append(event)
            }
        }
        
        return uniqueEvents
    }
    
    func saveEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        
        fetchEvents { result in
            switch result {
            case .success(let events):
                if events.map({ $0.id }).contains(event.id) {
                    self.deleteEvent(event) {_ in }
                }
                
                self.saveQueue.async {
                    self.context.perform {
                        do {
                            let eventCoreData = EventCoreData(context: self.context)
                            eventCoreData.name = event.name
                            eventCoreData.date = event.date
                            eventCoreData.time = try event.time?.encodeTime()
                            eventCoreData.category = event.category
                            eventCoreData.repeatOption = event.repeatOption
                            eventCoreData.alertOption = event.alertOption
                            eventCoreData.isAllDay = event.isAllDay
                            eventCoreData.calendarItemIdentifier = event.calendarItemIdentifier
                            eventCoreData.widgetBackgroundState = WidgetBackgroundState.encode(event.widgetBackgroundState)
                            eventCoreData.id = event.id
                            eventCoreData.note = event.note
                            try self.context.save()
                            completion(.success(()))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        
        saveQueue.async {
            self.context.perform {
                
                let eventsCoreData: [EventCoreData]
                var events: [Event]
                
                do {
                    eventsCoreData = try self.context.fetch(EventCoreData.fetchRequest())
                    events = try eventsCoreData.compactMap({
                        return try Event.makeEventFromCoreData($0)
                    })
                    let newEvents = self.updateEventsIfExpired(events)
                    completion(.success(self.makeUniqueEvents(for: newEvents)))
                } catch {
                    completion(.failure(error))
                    events = []
                }
            }
        }
    }
        
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        saveQueue.async {
            self.context.perform {
                do {
                    let fetchRequest: NSFetchRequest<EventCoreData> = EventCoreData.fetchRequest()
                    guard let id = event.id else { return }

                    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    
                    let results = try self.context.fetch(fetchRequest)
                    
                    for object in results {
                        self.context.delete(object)
                    }
                    
                    if self.context.hasChanges {
                        try self.context.save()
                    }
                    
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var eventContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

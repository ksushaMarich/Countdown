
import Foundation

struct AppGroupEvent: Codable, Equatable {
    let id: String
    let name: String
    let dateOfEvent: Date
    let image: Int
    let colors: Int
    let isPrivate: Bool
}

class AppGroupEventService {
    
    static let shared = AppGroupEventService()
    
    private let suiteName = "group.com.metamodern.countdown"
    private let key = "sharedEvents"
    
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: suiteName)
    }
    
    private init() {}
    
    func getAllEvents() -> [AppGroupEvent] {
        guard let data = userDefaults?.data(forKey: key) else { return [] }
        do {
            let events = try JSONDecoder().decode([AppGroupEvent].self, from: data)
            return events
        } catch {
            print("Ошибка декодирования событий: \(error)")
            return []
        }
    }
    
    func addEvent(_ event: AppGroupEvent) {
        var events = getAllEvents()
        events.append(event)
        save(events: events)
    }

    func removeEvent(_ eventId: String) {
        var events = getAllEvents()
        if let index = events.firstIndex(where: { $0.id == eventId }) {
            events.remove(at: index)
            save(events: events)
        }
    }
    
    private func save(events: [AppGroupEvent]) {
        do {
            let data = try JSONEncoder().encode(events)
            userDefaults?.set(data, forKey: key)
        } catch {
            print("Ошибка кодирования событий: \(error)")
        }
    }
    
    func clearAllEvents() {
        userDefaults?.removeObject(forKey: key)
    }
    
    func updateEvent(id: String, name: String, dateOfEvent: Date, image: Int, colors: Int, isPrivate: Bool) {
        var events = getAllEvents()
        
        if let index = events.firstIndex(where: { $0.id == id }) {
            let updatedEvent = AppGroupEvent(
                id: id,
                name: name,
                dateOfEvent: dateOfEvent,
                image: image,
                colors: colors,
                isPrivate: isPrivate
            )
            
            events[index] = updatedEvent
            
            save(events: events)
        }
    }
}



import EventKit

final class CalendarPermissionService {
    
    private let askedKey = "didAskForCalendarAccess"
    
    private var permissionHasBeenRequested: Bool {
        get { UserDefaults.standard.bool(forKey: askedKey) }
        set { UserDefaults.standard.set(newValue, forKey: self.askedKey) }
    }
    
    static let shared = CalendarPermissionService()
    
    private var eventStore = EKEventStore()
    
    enum PermissionStatus {
        case authorized
        case denied
        case notDetermined
    }
    
    private init() {}
    
    func checkPermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .authorized:
            completion(.authorized)
        case .notDetermined:
            if !permissionHasBeenRequested {
                permissionHasBeenRequested = true
                completion(.notDetermined)
            } else {
                completion(.denied)
            }
            
        default:
            completion(.denied)
        }
    }
    
    private func waitForCalendarsReady(
        retries: Int = 10,
        completion: @escaping ([EKCalendar]) -> Void
    ) {
        let calendars = eventStore.calendars(for: .event)
            .filter { $0.type != .subscription }
        
        if !calendars.isEmpty {
            completion(calendars)
        } else if retries > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.waitForCalendarsReady(retries: retries - 1, completion: completion)
            }
        } else {
            completion([])
        }
    }
    
    func fetchAllFutureEvents(
        from startDate: Date = Date(),
        completion: @escaping ([EKEvent]) -> Void
    ) {
        eventStore = EKEventStore()
        waitForCalendarsReady { calendars in
            guard !calendars.isEmpty,
                  let distantFuture = Calendar.current.date(byAdding: .year, value: 1, to: startDate)
            else {
                completion([])
                return
            }
            
            let predicate = self.eventStore.predicateForEvents(
                withStart: startDate,
                end: distantFuture,
                calendars: calendars
            )
            
            let events = self.eventStore.events(matching: predicate)
            let sortedEvents = events.sorted { $0.startDate < $1.startDate }
            
            completion(sortedEvents)
        }
    }
}

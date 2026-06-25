
import Foundation
import UserNotifications

final class NotificationService {
    
    // MARK: - Singleton
    static let shared = NotificationService()
    private init() {}
    
    // MARK: - Setting up permissions
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
                return
            } else {
                granted ? completion(true) : completion(false)
            }
        }
    }
    
    func updateNotificationDate(for option: String, to date: Date) -> Date {
        let options = EventOptionsType.alert.getOptions()
        let newDate: Date
        switch option {
        case options[1]:
            newDate = date.addingTimeInterval(-5 * 60)
        case options[2]:
            newDate = date.addingTimeInterval(-30 * 60)
        case options[3]:
            newDate = date.addingTimeInterval(-60 * 60)
        case options[4]:
            newDate = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        case options[5]:
            newDate = Calendar.current.date(byAdding: .day, value: -2, to: date) ?? date
        case options[6]:
            newDate = Calendar.current.date(byAdding: .day, value: -7, to: date) ?? date
        default:
            newDate = date
        }
        return newDate
    }
    
    // MARK: - Adding a notification
    func scheduleNotification(id: String, title: String = "Напоминание", body: String, date: Date, isPrivate: Bool, alertOption: String) {

        if isPrivate && !PrivateEventsVisibilityManager.shared.isPrivateEventsVisible ||  !NotificationsVisibilityStorage.shared.isNotificationsVisible {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: updateNotificationDate(for: alertOption, to: date))
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { _ in
            return 
        }
    }
    
    private func scheduleNotificationForAllEvents() {
        CoreDataManager.shared.fetchEvents { result in
            switch result {
            case .success(let events):
                for event in events {
                    guard let date = Date.makeDateForEvent(event) else { return }
                    self.scheduleNotification(id: event.id?.uuidString ?? "", body: event.name, date: date, isPrivate: event.isPrivate, alertOption: event.alertOption)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                if NotificationPermissionStorage.shared.getIsNotificationDenied() {
                    NotificationPermissionStorage.shared.saveIsNotificationDenied(false)
                    self.scheduleNotificationForAllEvents()
                }
                completion(true)
            case .denied:
                self.removeAllNotifications()
                NotificationPermissionStorage.shared.saveIsNotificationDenied(true)
                completion(false)
            case .notDetermined:
                self.requestAuthorization() { bool in
                    completion(bool)
                }
            case .ephemeral:
                if NotificationPermissionStorage.shared.getIsNotificationDenied() {
                    NotificationPermissionStorage.shared.saveIsNotificationDenied(false)
                    self.scheduleNotificationForAllEvents()
                }
                completion(true)
            @unknown default:
                completion(false)
            }
        }
    }
        
    // MARK: - Deleting notification
    func removeNotification(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // MARK: - Deleting all notifications
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

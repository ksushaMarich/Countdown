import Foundation

final class NotificationPermissionStorage {
    
    // MARK: - Singleton
    static let shared = NotificationPermissionStorage()
    private init() {}
    
    // MARK: - Ключ для UserDefaults
    private let key = "isNotificationDenied"
    
    func saveIsNotificationDenied(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getIsNotificationDenied() -> Bool {
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
}

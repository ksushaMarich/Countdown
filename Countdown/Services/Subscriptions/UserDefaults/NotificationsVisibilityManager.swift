import Foundation

final class NotificationsVisibilityStorage {
    
    // MARK: - Singleton
    static let shared = NotificationsVisibilityStorage()
    private init() {}
    
    // MARK: - Constants
    private let visibilityKey = "notificationsVisibilityKey"
    
    // MARK: - UserDefaults
    private var defaults: UserDefaults {
        UserDefaults.standard
    }
    
    // MARK: - Property
    var isNotificationsVisible: Bool {
        get {
            if defaults.object(forKey: visibilityKey) == nil {
                return true
            } else {
                return defaults.bool(forKey: visibilityKey)
            }
        }
        set {
            defaults.set(newValue, forKey: visibilityKey)
        }
    }
    
    // MARK: - Methods
    func setVisibilityValue(with value: Bool) {
        isNotificationsVisible = value
    }
    
    func toggleVisibility() {
        isNotificationsVisible.toggle()
    }
    
    func reset() {
        defaults.removeObject(forKey: visibilityKey)
    }
}


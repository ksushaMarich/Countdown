
import Foundation

final class PrivateEventsVisibilityManager {
    
    // MARK: - Singleton
    static let shared = PrivateEventsVisibilityManager()
    private init() {}
    
    // MARK: - Constants
    private let visibilityKey = "privateEventsVisibilityKey"
    private let appGroupID = "group.com.metamodern.countdown"
    
    // MARK: - UserDefaults
    private var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
    
    // MARK: - Property
    var isPrivateEventsVisible: Bool {
        get {
            guard let defaults = defaults else {
                return true
            }
            
            if defaults.object(forKey: visibilityKey) == nil {
                return true
            } else {
                return defaults.bool(forKey: visibilityKey)
            }
        }
        set {
            defaults?.set(newValue, forKey: visibilityKey)
        }
    }
    
    // MARK: - Methods
    func setVisibilityValue(with value: Bool) {
        isPrivateEventsVisible = value
    }
    
    func toggleVisibility() {
        isPrivateEventsVisible.toggle()
    }
    
    func reset() {
        defaults?.removeObject(forKey: visibilityKey)
    }
}

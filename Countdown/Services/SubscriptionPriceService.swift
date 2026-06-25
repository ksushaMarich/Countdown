
enum SubscriptionType {
    case monthly
    case yearly
    case lifetime
}

final class SubscriptionService {
    
    // MARK: week price
    
    func localizedPrice(for type: SubscriptionType) -> Double {
        switch type {
        case .monthly: return 12.99
        case .yearly: return 9.49
        case .lifetime: return 12.99
        }
    }
}

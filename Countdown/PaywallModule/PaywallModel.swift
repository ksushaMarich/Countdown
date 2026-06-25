
struct PaywallCellInfo {
    
    let timeInfo: String
    let description: String
    let price: String
    let priceDescription: String
    
    // MARK: week price
    
    static func getPaywallCellsInfo() -> [PaywallCellInfo] {
        let subscriptionService = SubscriptionService()
        
        return [PaywallCellInfo(timeInfo: "Lifetime", description: "Pay once, use forever", price: "$\(subscriptionService.localizedPrice(for: .lifetime))", priceDescription: " once"), PaywallCellInfo(timeInfo: "Annual", description: "Only 0,79 per month", price: "$\(subscriptionService.localizedPrice(for: .yearly))", priceDescription: "/Year"), PaywallCellInfo(timeInfo: "Monthly", description: "Perfect way to try", price: "$\(subscriptionService.localizedPrice(for: .monthly))", priceDescription: "/Month")]
    }
}

enum LinkType: String {
    case termsOfUse = "https://www.termsfeed.com/live/aa79ca62-c3d9-4017-9876-812df9865e3a"
    case privacyPolicy = "https://www.termsfeed.com/live/baa14f51-0eed-4cb3-8c1f-6e4d944949e7"
}

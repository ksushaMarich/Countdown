import StoreKit

@available(iOS 15.0, *)
class SubscriptionsService {
    
    static let shared = SubscriptionsService()
    private init() { }
    
    var products: [Product] = []
    var hasSubscription: Bool = false
    
    private var productIdentifiers: [String] {
        ["countdown.lifetime.once", "countdown.year", "countdown.monthly"]
    }
    
    func fetchProducts() async throws {
        do {
            let storeProducts = try await Product.products(for: productIdentifiers)
            self.products = storeProducts.sorted(by: { $0.price > $1.price })
            print("<<< products \(products.count) = \(products)")
            NotificationCenter.default.post(name: NSNotification.Name("IAPProductsFetched"), object: nil)
        } catch {
            throw error
        }
    }
    
    @discardableResult
    func buySubscription(product: Product) async throws -> Transaction? {
        print("<<< buySubscription: \(product.id), \(product.subscription?.subscriptionPeriod), \(product.price), \(product.subscription?.introductoryOffer?.period)")
        
        guard self.hasSubscription == false else {
            return nil
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            NotificationCenter.default.post(name: NSNotification.Name("IAPPurchaseSuccessful"), object: nil)
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func hasActiveSubscription() async -> Bool {
        do {
            if products.isEmpty {
                print("<<< products.isEmpty")
                do {
                    try await fetchProducts()
                } catch {
                    print("<< error = \(error)")
                }
            }
            for await result in Transaction.currentEntitlements {
                let transaction = try checkVerified(result)
                if transaction.productType == .autoRenewable || transaction.productType == .nonRenewable || transaction.productType == .nonConsumable {
                    self.hasSubscription = true
                    return true
                }
            }
        } catch {
            print("Failed to check subscriptions: \(error.localizedDescription)")
            return false
        }
        return false
    }
    
    func verifyPurchase() async -> Bool {
        guard let result = await Transaction.latest(for: "appStrore") else {
            return false
        }
        
        switch result {
        case .verified:
            self.hasSubscription = true
            return true
        case .unverified:
            return false
        }
    }
    
    func getSubscriptionPeriodInMonths(for product: Product) -> Int? {
        guard let subscriptionPeriod = product.subscription?.subscriptionPeriod else {
            // Not a subscription product
            return nil
        }
        
        let unitCount = subscriptionPeriod.value
        let unitType = subscriptionPeriod.unit
        
        switch unitType {
        case .day:
            // Approximate the number of months from days (assume 30 days in a month)
            return unitCount / 30
        case .week:
            // Approximate the number of months from weeks (assume 4 weeks in a month)
            return unitCount / 4
        case .month:
            return unitCount
        case .year:
            // Convert years to months
            return unitCount * 12
        @unknown default:
            // Handle unknown cases
            return nil
        }
    }
    
    func getPricePerWeek(for product: Product) -> Decimal? {
        guard let subscription = product.subscription else {
            // Не является подписочным продуктом
            return nil
        }
        
        // Получаем цену подписки
        let price = product.price
        
        // Получаем период подписки
        let subscriptionPeriod = subscription.subscriptionPeriod
        let unitCount = subscriptionPeriod.value
        let unitType = subscriptionPeriod.unit
        
        // Общая сумма недель
        var totalWeeks: Int = 0
        switch unitType {
        case .day:
            // Перевод дней в недели (7 дней в неделе)
            totalWeeks = unitCount / 7
        case .week:
            totalWeeks = unitCount
        case .month:
            // Перевод месяцев в недели (предполагаем 4 недели в месяце)
            totalWeeks = unitCount * 4
        case .year:
            // Перевод лет в недели (52 недели в году)
            totalWeeks = unitCount * 52
        @unknown default:
            return nil
        }
        
        // Вычисляем цену за неделю
        if totalWeeks > 0 {
            let pricePerWeek = price / Decimal(totalWeeks)
            return pricePerWeek
        }
        
        return nil
    }
    func getPricePerMonth(for product: Product) -> Decimal? {
        guard let subscription = product.subscription else {
            // Not a subscription product
            return nil
        }
        
        // Get the subscription price
        let price = product.price
        
        // Get the subscription period
        let subscriptionPeriod = subscription.subscriptionPeriod
        let unitCount = subscriptionPeriod.value
        let unitType = subscriptionPeriod.unit
        
        // Calculate the total number of months
        var totalMonths: Int = 0
        switch unitType {
        case .day:
            // Approximate the number of months from days (assume 30 days in a month)
            totalMonths = unitCount / 30
        case .week:
            // Approximate the number of months from weeks (assume 4 weeks in a month)
            totalMonths = unitCount / 4
        case .month:
            totalMonths = unitCount
        case .year:
            // Convert years to months
            totalMonths = unitCount * 12
        @unknown default:
            return nil
        }
        
        // Calculate the price per month
        if totalMonths > 0 {
            let pricePerMonth = price / Decimal(totalMonths)
            return pricePerMonth
        }
        
        return nil
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    func restorePurchases() async throws {
        // Синхронизация транзакций с App Store
        try await AppStore.sync()
        
        // Проверка текущих подписок
        let hasActiveSubscription = await hasActiveSubscription()
        
        if hasActiveSubscription {
            // Если подписка активна, обновляем состояние
            self.hasSubscription = true
            NotificationCenter.default.post(name: NSNotification.Name("IAPRestoreSuccessful"), object: nil)
        } else {
            // Если подписка не активна, можно уведомить пользователя
            NotificationCenter.default.post(name: NSNotification.Name("IAPRestoreFailed"), object: nil)
        }
    }
}

extension SubscriptionsService {
    enum StoreKitError: Error {
        case verificationFailed
    }
}

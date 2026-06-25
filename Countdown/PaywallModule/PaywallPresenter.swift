import StoreKit

protocol PaywallViewInput: AnyObject {
    var presenter: PaywallViewOutput? { get set }
    func reloadProducts()
    func showLoader()
    func hideLoader()
}

protocol PaywallViewOutput: AnyObject {
    var view: PaywallViewInput? { get set }
    func viewDidLoad()
    var products: [Product] { get }
    func productSelected(at index: Int)
    func presentWebView(with linkType: LinkType)
}

// MARK: - Presenter

final class PaywallPresenter {
    weak var view: PaywallViewInput?
    var router: PaywallRouterProtocol?
    private let subscriptionsService = SubscriptionsService.shared
    
    private(set) var products: [Product] = []
}

extension PaywallPresenter: PaywallViewOutput {
    
    func viewDidLoad() {
        Task {
            do {
                try await subscriptionsService.fetchProducts()
                products = subscriptionsService.products.sorted(by: { $0.displayPrice > $1.displayPrice })
                await MainActor.run {
                    view?.reloadProducts()
                }
            } catch {
                print("<<< Failed to load products: \(error)")
            }
        }
    }
    
    func productSelected(at index: Int) {
        guard index < products.count else { return }
        let product = products[index]
        
        view?.showLoader()
        Task {
            do {
                try await SubscriptionsService.shared.buySubscription(product: product)
                
                if await SubscriptionsService.shared.hasActiveSubscription() {
                    self.router?.dismissPaywall()
                } else {
                    view?.hideLoader()
                }
                
                view?.hideLoader()
            } catch {
                view?.hideLoader()
            }
        }
    }
    
    func presentWebView(with linkType: LinkType) {
        router?.presentWebViewController(with: linkType)
    }
}

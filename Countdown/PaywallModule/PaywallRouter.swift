import UIKit

protocol PaywallRouterProtocol {
    func presentWebViewController(with type: LinkType)
     func dismissPaywall()
}

class PaywallRouter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension PaywallRouter: PaywallRouterProtocol {
    func presentWebViewController(with type: LinkType) {
        viewController.present(WebViewController(urlString: type.rawValue), animated: true)
    }
    
    func dismissPaywall() {
        DispatchQueue.main.async {
            self.viewController.dismiss(animated: true)
        }
    }
}

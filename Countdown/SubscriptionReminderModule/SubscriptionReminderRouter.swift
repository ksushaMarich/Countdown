
import UIKit

protocol SubscriptionReminderRouterProtocol: AnyObject {
    func dismissAndShowPaywall()
}

final class SubscriptionReminderRouter {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension SubscriptionReminderRouter: SubscriptionReminderRouterProtocol {
    func dismissAndShowPaywall() {
        viewController.dismiss(animated: true) {
            let paywallVC = PaywallModuleBuilder.build()
            paywallVC.modalPresentationStyle = .overFullScreen
            
            if let topVC = UIApplication.shared.topMostViewController() {
                topVC.present(paywallVC, animated: false)
            }
        }
    }
}


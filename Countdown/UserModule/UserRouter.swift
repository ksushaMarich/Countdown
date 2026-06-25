
import UIKit

protocol UserModuleRouterProtocol: AnyObject {
    func presentPaywall()
    func presentWebViewController(with type: LinkType)
}

class UserRouter {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension UserRouter: UserModuleRouterProtocol {
    func presentPaywall() {
        let viewController = PaywallModuleBuilder.build()
        viewController.modalPresentationStyle = .overFullScreen
        
        self.viewController.present(viewController, animated: false)
    }
    
    func presentWebViewController(with type: LinkType) {
        viewController.present(WebViewController(urlString: type.rawValue), animated: true)
    }
}

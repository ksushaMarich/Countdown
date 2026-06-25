
import UIKit

final class PaywallModuleBuilder {
    static func build() -> UIViewController {
        let view = PaywallViewController()
        let presenter = PaywallPresenter()
        let router = PaywallRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}

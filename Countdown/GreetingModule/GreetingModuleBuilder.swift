
import UIKit

final class GreetingModuleBuilder {
    static func build() -> UIViewController {
        let view = GreetingViewController()
        let presenter = GreetingPresenter()
        let router = GreetingModuleRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}


import UIKit

class UserEventModuleBuilder {
    static func build() -> UIViewController {
        let view = UserViewController()
        let presenter = UserPresenter()
        let router = UserRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}

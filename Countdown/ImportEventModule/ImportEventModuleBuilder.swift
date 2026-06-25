
import UIKit

class ImportEventModuleBuilder {
    static func build() -> UIViewController {
        let view = ImportEventViewController()
        let presenter = ImportEventPresenter()
        let router = ImportEventRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}

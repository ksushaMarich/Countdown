
import UIKit

class NewEventModuleBuilder {
    static func build(event: Event? = nil) -> UIViewController {
        let view = NewEventViewController()
        let presenter = NewEventPresenter(event: event)
        let router = NewEventModuleRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}

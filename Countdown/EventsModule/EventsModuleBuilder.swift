
import UIKit

final class EventsModuleBuilder {
    static func build(id: String? = nil) -> UIViewController {
        let view = EventsViewController()
        let presenter = EventsPresenter(eventId: id)
        let router = EventsModuleRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}

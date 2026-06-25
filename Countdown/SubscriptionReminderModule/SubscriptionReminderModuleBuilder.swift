
import UIKit

final class SubscriptionReminderModuleBuilder {
    static func build() -> UIViewController {
        let view = SubscriptionReminderViewController()
        let presenter = SubscriptionReminderPresenter()
        let router = SubscriptionReminderRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}


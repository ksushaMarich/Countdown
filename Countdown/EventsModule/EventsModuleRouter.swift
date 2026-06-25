
import UIKit

protocol EventsModuleRouterProtocol: AnyObject {
    func navigateToNewEventModule()
    func navigateToNewEventModule(with event: Event)
    func navigateToImportEventModule()
    func navigateToGreetingModule()
    func presentSubscriptionReminderViewController()
    func showErrorAlert()
}

final class EventsModuleRouter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension EventsModuleRouter: EventsModuleRouterProtocol {
    
    func navigateToNewEventModule() {
        viewController.navigationController?.pushViewController(NewEventModuleBuilder.build(), animated: true)
    }
    
    func navigateToNewEventModule(with event: Event) {
        viewController.navigationController?.pushViewController(NewEventModuleBuilder.build(event: event), animated: true)
    }
    
    func navigateToGreetingModule() {
        viewController.navigationController?.pushViewController(GreetingModuleBuilder.build(), animated: true)
    }
    
    func showErrorAlert() {
        viewController.showAlert(title: "Service Temporarily Unavailable", message: "Please try again later") {}
    }
    
    func navigateToImportEventModule() {
        viewController.navigationController?.pushViewController(ImportEventModuleBuilder.build(), animated: true)
    }
    
    func presentSubscriptionReminderViewController() {
        viewController.present(SubscriptionReminderModuleBuilder.build(), animated: true)
    }
}

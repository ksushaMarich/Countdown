
import UIKit

protocol GreetingModuleRouterProtocol: AnyObject {
    func navigateToNewEventModule()
    func navigateToImportEventModule()
}

final class GreetingModuleRouter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension GreetingModuleRouter: GreetingModuleRouterProtocol {
    func navigateToNewEventModule() {
        viewController.navigationController?.pushViewController(NewEventModuleBuilder.build(), animated: true)
    }
    
    func navigateToImportEventModule() {
        viewController.navigationController?.pushViewController(ImportEventModuleBuilder.build(), animated: true)
    }
}

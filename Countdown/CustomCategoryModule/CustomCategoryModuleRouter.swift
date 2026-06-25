
import UIKit

protocol CustomCategoryModuleRouterProtocol {
}

final class CustomCategoryModuleRouter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension CustomCategoryModuleRouter: CustomCategoryModuleRouterProtocol {
}

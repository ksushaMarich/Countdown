
import UIKit

final class CustomCategoryModuleBuilder {
    static func build(completion: @escaping ((CustomCategoryModel) -> Void)) -> UIViewController {
        let view = CustomCategoryViewController()
        let presenter = CustomCategoryPresenter(completion: completion)
        let router = CustomCategoryModuleRouter(viewController: view)
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
}

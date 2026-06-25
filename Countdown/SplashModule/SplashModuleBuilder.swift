
import UIKit

class SplashModuleBuilder {
    static func build(id: String?) -> UIViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter(id: id)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}

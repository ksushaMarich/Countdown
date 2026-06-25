
import UIKit

final class SplashModuleRouter {
    
    static func showStartScreen(id: String?){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        CoreDataManager.shared.fetchEvents { result in
            
            switch result {
            case .success(let events):
                let viewController: UIViewController
                if events.isEmpty {
                    viewController = GreetingModuleBuilder.build()
                } else {
                    viewController = EventsModuleBuilder.build(id: id)
                }
                
                if #available(iOS 18.0, *) {
                    window.rootViewController = MainTabBarController(eventsRootViewController: viewController)
                } else {
                    window.rootViewController = UINavigationController(rootViewController: viewController)
                }

                UIView.transition(with: window,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: nil)
            case .failure:
                window.rootViewController?.showAlert(title: "Service Temporarily Unavailable", message: "Please try again later") {}
            }
        }
    }
}

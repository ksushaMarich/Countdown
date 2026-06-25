
import UIKit

protocol ImportEventModuleRouterProtocol: AnyObject {
    func popViewController()
    func navigateToNextScreen()
    func navigateToGreetingModule()
    func presentPaywall()
}

final class ImportEventRouter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    private func getEventsCount( completion: @escaping (Int) -> Void) {
        
        CoreDataManager.shared.fetchEvents { result in
            switch result {
            case .success(let events):
                completion(events.count)
            case .failure(_):
                completion(0)
            }
        }
    }
}

extension ImportEventRouter: ImportEventModuleRouterProtocol {
    func popViewController() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func navigateToGreetingModule() {
        viewController.navigationController?.pushViewController(GreetingModuleBuilder.build(), animated: true)
    }
    
    func navigateToNextScreen() {
        if let navigationController = viewController.navigationController {
            
            getEventsCount() { eventsCount in
                let stack = navigationController.viewControllers
                
                if stack.count >= 2, (((stack[stack.count - 2]) as? EventsViewController) != nil), eventsCount != 0 {
                    self.popViewController()
                } else if eventsCount != 0 {
                    self.viewController.navigationController?.pushViewController(EventsModuleBuilder.build(), animated: true)
                } else {
                    self.navigateToGreetingModule()
                }
            }
        }
    }
    
    func presentPaywall() {
        let viewController = PaywallModuleBuilder.build()
        viewController.modalPresentationStyle = .overFullScreen
        
        self.viewController.present(viewController, animated: false)
    }
}

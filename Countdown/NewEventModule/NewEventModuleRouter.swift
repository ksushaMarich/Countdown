
import UIKit

protocol NewEventModuleRouterProtocol: AnyObject {
    func popViewController()
    func pushEventsViewController()
    func showErrorAlert()
    func presentCustomCategoryModule(safeAreaTopHeight: CGFloat, completion: @escaping ((CustomCategoryModel) -> Void))
    func presentPaywall()
}

final class NewEventModuleRouter {
    
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

extension NewEventModuleRouter: NewEventModuleRouterProtocol {
    
    func popViewController() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func pushEventsViewController() {
        if let navigationController = viewController.navigationController {
            
            getEventsCount() { eventsCount in
                let stack = navigationController.viewControllers
                
                if stack.count >= 2, (((stack[stack.count - 2]) as? EventsViewController) != nil), eventsCount != 0 {
                    self.popViewController()
                } else if eventsCount != 0 {
                    self.viewController.navigationController?.pushViewController(EventsModuleBuilder.build(), animated: true)
                } else {
                    self.popViewController()
                }
            }
        }
    }
    
    func showErrorAlert() {
        viewController.showAlert(title: "Service Temporarily Unavailable", message: "Please try again later") {}
    }
    
    func presentCustomCategoryModule(safeAreaTopHeight: CGFloat, completion: @escaping ((CustomCategoryModel) -> Void)) {
        let viewController = CustomCategoryModuleBuilder.build(completion: completion)
        viewController.modalPresentationStyle = .overFullScreen
        
        self.viewController.present(viewController, animated: false)
    }
    
    func presentPaywall() {
        let viewController = PaywallModuleBuilder.build()
        viewController.modalPresentationStyle = .overFullScreen
        
        self.viewController.present(viewController, animated: false)
    }
}

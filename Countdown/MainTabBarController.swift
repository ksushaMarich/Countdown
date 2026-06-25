
import UIKit

@available(iOS 18.0, *)
class MainTabBarController: UITabBarController {
    
    let eventsRootViewController: UIViewController
    
    private lazy var eventsViewController = UINavigationController(rootViewController: eventsRootViewController)
    private lazy var usersViewController = UINavigationController(rootViewController: UserEventModuleBuilder.build())
    
    init(eventsRootViewController: UIViewController) {
        self.eventsRootViewController = eventsRootViewController
        super.init(nibName: nil, bundle: nil)
        viewControllers = [eventsViewController, usersViewController]
        eventsViewController.tabBarItem = UITabBarItem(title: "Events",
                                                       image: .counter, tag: 0)
        
        usersViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                      image: .profile, tag: 1)
        tabBar.tintColor = .themeRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

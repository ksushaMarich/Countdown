import UIKit

extension UIViewController {
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

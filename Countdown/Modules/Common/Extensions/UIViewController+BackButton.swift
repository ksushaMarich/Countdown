import UIKit

extension UIViewController {
    func setBackButton(color: UIColor = .white) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        navigationItem.leftBarButtonItem?.tintColor = color
    }
}

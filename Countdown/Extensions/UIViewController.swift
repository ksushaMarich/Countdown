
import UIKit

extension UIViewController {
    
    func showAlert(
        title: String,
        message: String,
        confirmTitle: String? = nil,
        cancelTitle: String? = nil,
        confirmStyle: UIAlertAction.Style = .default,
        onConfirm:  @escaping () -> Void 
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelTitle != nil {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default))
        }
        if confirmTitle != nil {
            alert.addAction(UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
                onConfirm()
            })
        }
        present(alert, animated: true)
    }
}

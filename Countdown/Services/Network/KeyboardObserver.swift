import UIKit

class KeyboardObserver {
    private var showHandler: ((_ keyboardHeight: CGFloat) -> Void)?
    private var hideHandler: (() -> Void)?
    
    func add(showHandler: @escaping ((CGFloat) -> Void), hideHandler: @escaping (() -> Void)) {
        self.showHandler = showHandler
        self.hideHandler = hideHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            showHandler?(keyboardSize.height)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        hideHandler?()
    }
}

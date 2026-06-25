
import UIKit

extension UIView {
    
    func superview<T: UIView>(of type: T.Type) -> T? {
        var view = self.superview
        while view != nil {
            if let match = view as? T {
                return match
            }
            view = view?.superview
        }
        return nil
    }
}

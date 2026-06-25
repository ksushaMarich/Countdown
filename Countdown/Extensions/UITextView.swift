
import UIKit

extension UITextView {
    
    func requiredHeight() -> CGFloat {
        let fixedWidth = self.frame.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
    }
}

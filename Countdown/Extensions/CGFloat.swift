
import UIKit

extension CGFloat {
    
    static func proportionalToDesignHeight(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.height * (value / 852.0)
    }
    
    static func proportionalToDesignWidth(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * (value / 393.0)
    }
}

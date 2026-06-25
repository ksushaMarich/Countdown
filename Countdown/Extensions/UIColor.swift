
import UIKit

extension UIColor {
    var encoded: Data? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return try? JSONEncoder().encode([r, g, b, a])
    }
}

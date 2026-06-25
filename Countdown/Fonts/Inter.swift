
import UIKit

enum InterFont: String {
    case regular = "Inter-Regular"
    case bold = "Inter-Bold"
    case italic = "Inter-Italic"
    case medium = "Inter-Medium"
    case light = "Inter-Light"

    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            print("Font \(self.rawValue) not found. The system font was used.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}


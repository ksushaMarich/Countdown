
import UIKit

enum HelveticaNeueFont: String {
    case light = "HelveticaNeue-Light"
    case regular = "HelveticaNeue"
    case medium = "HelveticaNeue-Medium"
    case bold = "HelveticaNeue-Bold"
    case italic = "HelveticaNeue-Italic"
    
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            print("Font \(self.rawValue) not found. The system font was used.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

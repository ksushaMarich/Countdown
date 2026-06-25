
import SwiftUI

enum HelveticaNeueFont: String {
    case light = "HelveticaNeue-Light"
    case regular = "HelveticaNeue"
    case medium = "HelveticaNeue-Medium"
    case bold = "HelveticaNeue-Bold"
    case italic = "HelveticaNeue-Italic"
    
    func of(size: CGFloat) -> Font {
        if UIFont(name: self.rawValue, size: size) != nil {
            return Font.custom(self.rawValue, size: size)
        } else {
            print("Font \(self.rawValue) not found. System font was used.")
            return Font.system(size: size)
        }
    }
}

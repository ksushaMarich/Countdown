
import SwiftUI

enum InterFont: String {
    case regular = "Inter-Regular"
    case bold = "Inter-Bold"
    case italic = "Inter-Italic"
    case medium = "Inter-Medium"
    case light = "Inter-Light"
    
    func of(size: CGFloat) -> Font {
        if UIFont(name: self.rawValue, size: size) != nil {
            return Font.custom(self.rawValue, size: size)
        } else {
            print("Font \(self.rawValue) not found. System font was used.")
            return Font.system(size: size)
        }
    }
}


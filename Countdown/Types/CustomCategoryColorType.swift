
import UIKit

enum CustomCategoryColorType: Int {
    case pink, mint, aqua, sky, lavender, brown, olive, sage, slate, mauve, red, green, teal, blue, purple
    
    static func giveColors() -> [UIColor] {
        [.pinkCustomCategory, .mintCustomCategory, .aquaCustomCategory, .skyCustomCategory, .lavenderCustomCategory, .brownCustomCategory, .oliveCustomCategory, .sageCustomCategory, .slateCustomCategory, .mauveCustomCategory, .redCustomCategory, .greenCustomCategory, .tealCustomCategory, .blueCustomCategory, .purpleCustomCategory]
    }
}

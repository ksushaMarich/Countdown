
import UIKit

struct UIElements {
    
    static var eventsTitleLabel: UILabel {
        let label = UILabel()
        label.text = "Events"
        label.font = InterFont.medium.of(size: 38)
        label.textColor = .blackFont
        return label
    }
}

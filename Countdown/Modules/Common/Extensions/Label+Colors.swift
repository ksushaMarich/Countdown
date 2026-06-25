import UIKit

struct Text {
    let text: String
    let color: UIColor
    let font: UIFont
}

extension UILabel {
    func addColors(texts: [Text]) -> UILabel {
        numberOfLines = 0
        let attributedString = NSMutableAttributedString()
        
        texts.forEach { text in
            attributedString.append(
                NSMutableAttributedString(
                    string: text.text,
                    attributes: [
                        NSAttributedString.Key.font: text.font,
                        NSAttributedString.Key.foregroundColor: text.color
                    ]
                )
            )
            attributedString.append(
                NSMutableAttributedString(
                    string: " ",
                    attributes: [
                        NSAttributedString.Key.font: text.font,
                        NSAttributedString.Key.foregroundColor: text.color
                    ]
                )
            )
        }
        
        self.attributedText = attributedString
        return self
    }
}

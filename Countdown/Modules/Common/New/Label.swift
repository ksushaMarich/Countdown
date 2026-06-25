import UIKit

extension UIView {
    static func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    static func systemLabel(_ text: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        return label.font(.systemFont(ofSize: fontSize)).textColor(textColor)
    }
    
    static func boldLabel(_ text: String, fontSize: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        return label.font(.boldSystemFont(ofSize: fontSize)).textColor(textColor)
    }
}

extension UILabel {
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult
    func numberOfLines(_ value: Int) -> Self {
        self.numberOfLines = value
        return self
    }
    
    @discardableResult
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }
}

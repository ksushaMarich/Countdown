import UIKit

extension UIView {
    static func imageView(_ name: String) -> UIImageView {
        return UIImageView(image: .init(named: name))
    }
    
    static func imageView(_ image: UIImage?) -> UIImageView {
        return UIImageView(image: image)
    }
}

extension UIImageView {
    @discardableResult
    func setColor(_ color: UIColor) -> Self {
        let image = self.image
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func contentMode(_ value: ContentMode) -> Self {
        self.contentMode = value
        return self
    }
}

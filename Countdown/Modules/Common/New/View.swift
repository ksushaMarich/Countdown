import UIKit

extension UIView {
    static func empty() -> UIView {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        return emptyView
    }
    
    static func padding(height: CGFloat) -> UIView {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        if height != 0 {
            emptyView.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
        }
        
        return emptyView
    }
    
    static func emptyWidthView(width: CGFloat = 0) -> UIView {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        if width != 0 {
            emptyView.snp.makeConstraints { make in
                make.width.equalTo(width)
            }
        }

        return emptyView
    }
    
    static func containerView(with view: UIView, insets: UIEdgeInsets) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(insets.top)
            make.leading.equalToSuperview().inset(insets.left)
            make.trailing.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
        }
        return containerView
    }
}

extension UIView {
    @discardableResult
    func transform(_ value: CGAffineTransform) -> UIView {
        self.transform = value
        return self
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ value: Bool) -> Self {
        self.isUserInteractionEnabled = value
        return self
    }
    
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat, clipsToBounds: Bool = false) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
        return self
    }
    
    @discardableResult
    func roundCorners(corners: CACornerMask, radius: CGFloat) -> Self {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        return self
    }
    
    @discardableResult
    func roundTopCorners(radius: CGFloat) -> Self {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return self
    }
    
    @discardableResult
    func roundBottomCorners(radius: CGFloat) -> Self {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return self
    }
    
    @discardableResult
    /// Добавляет картинку как background image
    func image(_ named: String, color: UIColor? = nil, contrentMode: ContentMode = .scaleToFill) -> Self {
        return self.image(.init(named: named), color: color, contrentMode: contrentMode)
    }
    
    @discardableResult
    /// Добавляет картинку как background image
    func image(_ image: UIImage?, color: UIColor? = nil, contrentMode: ContentMode = .scaleToFill) -> Self {
        let imageView: UIImageView
        if let color = color {
            imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = color
        } else {
            imageView = UIImageView(image: image)
        }
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.contentMode = contrentMode
        return self
    }
    
    @discardableResult
    /// Добавляет  image сверху
    func addImage(_ named: String, color: UIColor? = nil, contrentMode: ContentMode = .scaleToFill) -> Self {
        return self.addImage(.init(named: named), color: color, contrentMode: contrentMode)
    }
    
    @discardableResult
    /// Добавляет  image сверху
    func addImage(_ image: UIImage?, color: UIColor? = nil, contrentMode: ContentMode = .scaleToFill) -> Self {
        let imageView: UIImageView
        if let color = color {
            imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = color
        } else {
            imageView = UIImageView(image: image)
        }
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.contentMode = contrentMode
        return self
    }
    
    // Snap kit
    
    @discardableResult
    func height(_ value: CGFloat) -> Self {
        self.snp.makeConstraints { make in
            make.height.equalTo(value)
        }
        
        return self
    }
    
    @discardableResult
    func width(_ value: CGFloat) -> Self {
        self.snp.makeConstraints { make in
            make.width.equalTo(value)
        }
        
        return self
    }
    
    @discardableResult
    func minHeight(_ value: CGFloat) -> Self {
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(value)
        }
        
        return self
    }
    
    @discardableResult
    func minWidth(_ value: CGFloat) -> Self {
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(value)
        }
        
        return self
    }
    
    @discardableResult
    func size(_ value: CGFloat) -> Self {
        self.snp.makeConstraints { make in
            make.size.equalTo(value)
        }
        
        return self
    }
    
    @discardableResult
    func size(_ value: CGSize) -> Self {
        self.snp.makeConstraints { make in
            make.size.equalTo(value)
        }
        
        return self
    }
    
    @discardableResult
    func circle() -> Self { // Need call after viewWillAppear
        cornerRadius(bounds.height, clipsToBounds: true)
        return self
    }
    
    @discardableResult
    func addView(_ view: UIView, parent: UIView) -> Self {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            parent.addSubview(view)
            view.snp.makeConstraints { make in
                make.edges.equalTo(self)
            }
        }
        return self
    }
    
    @discardableResult
    func isHidden(_ value: Bool) -> Self {
        self.isHidden = value
        return self
    }
    
    @discardableResult
    func alpha(_ value: CGFloat) -> Self {
        self.alpha = value
        return self
    }
    
    @discardableResult
    func setTag(_ value: Int) -> Self {
        self.tag = value
        return self
    }
}

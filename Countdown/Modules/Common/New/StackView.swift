import UIKit

extension UIView {
    static func horizontalStackView(views: [UIView]) -> UIStackView { .init(axis: .horizontal, views: views)}
    static func verticalStackView(views: [UIView]) -> UIStackView { .init(axis: .vertical, views: views)}
    
    // Helpers
    
    static func centerStackView(views: [UIView]) -> UIStackView {
        .init(axis: .horizontal, views: [.empty()] + views + [.empty()]).distribution(.equalCentering)
    }
    
    static func rightStackView(views: [UIView]) -> UIStackView {
        .init(axis: .horizontal, views: [.empty()] + views)
    }
    
    static func leftStackView(views: [UIView]) -> UIStackView {
        .init(axis: .horizontal, views: views + [.empty()])
    }
}

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        views: [UIView]
    ) {
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        views.forEach { self.addArrangedSubview($0) }
    }
    
    @discardableResult
    func spacing(_ value: CGFloat) -> Self {
        self.spacing = value
        return self
    }
    
    @discardableResult
    func update(views: [UIView]) -> Self {
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            self.addArrangedSubview($0)
        }
        return self
    }
    
    @discardableResult
    func updateWithAnimate(views: [UIView]) -> Self {
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            self.addArrangedSubview($0)
        }
        return self
    }
    
    @discardableResult
    func contentInset(_ value: CGFloat) -> Self {
        self.layoutMargins = .init(value)
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func contentInset(_ value: UIEdgeInsets) -> Self {
        self.layoutMargins = value
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    func border(borderWidth: CGFloat, color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    func alignment(_ value: Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @discardableResult
    func distribution(_ value: Distribution) -> Self {
        self.distribution = value
        return self
    }
}

extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

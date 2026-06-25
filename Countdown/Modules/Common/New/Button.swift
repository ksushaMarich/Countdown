import UIKit

class CustomButton: UIButton {
    private let tapHandler: () -> Void
    
    init(tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        titleLabel?.adjustsFontSizeToFitWidth = true
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                alpha = 0.4
            }
            else {
                alpha = 1
            }
            super.isHighlighted = newValue
        }
    }
    
    @objc private func buttonDidTap() {
        tapHandler()
    }
}

extension UIView {
    static func candyButton(tapHandler: @escaping () -> Void) -> UIButton {
        return CandyButton(tapHandler: tapHandler)
    }
    
    static func button(tapHandler: @escaping () -> Void) -> UIButton {
        return CustomButton(tapHandler: tapHandler)
    }
}


extension UIButton {
    @discardableResult
    func setupTitle(_ text: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(text, for: state)
        return self
    }
    
    @discardableResult
    func setupImage(_ name: String, for state: UIControl.State = .normal) -> Self {
        self.setImage(.init(named: name), for: state)
        return self
    }
    
    @discardableResult
    func setupTextColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func setupFont(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func addContentInset(_ value: CGFloat) -> Self {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
        return self
    }
}

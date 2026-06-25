import UIKit

public typealias EmptyClosure = () -> Void
public typealias VerticalClosure = (Int) -> Void
public typealias SideClosure = (Side) -> Void
public typealias SelfClosure = (UIView) -> Void

public enum Side {
    case left
    case right
}

extension UIView {
    @discardableResult
    public func addTapGesture(action: EmptyClosure?) -> Self {
        addGestureRecognizer(BlockTap(action: action))
        isUserInteractionEnabled = true
        return self
    }
    
    @discardableResult
    public func addTapGestureAndGetSelf(action: SelfClosure?) -> Self {
        addTapGesture { [weak self] in
            if let self {
                action?(self)
            }
        }
        return self
    }
    
    
    @discardableResult
    public func addTapGestureForEachSide(action: SideClosure?) -> Self {
        let leftView = UIView.empty().addTapGesture {
            action?(.left)
        }
        addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(snp.centerX)
        }
        
        let rightView = UIView.empty().addTapGesture {
            action?(.right)
        }
        addSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(snp.centerX)
        }
        isUserInteractionEnabled = true
        return self
    }
    
    @discardableResult
    public func addTapGestureVertical(counts: Int, action: @escaping VerticalClosure) -> Self { // От 1
        let stackView = UIView.verticalStackView(views: []).distribution(.fillEqually)
        (1...counts).forEach { index in
            stackView.addArrangedSubview(
                .empty().addTapGesture {
                    action(index)
                }
            )
        }
        isUserInteractionEnabled = true
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return self
    }

    public func addSwipeDownGesture(action: EmptyClosure?) {
        let block = BlockSwipe(action: action)
        block.direction = .down
        addGestureRecognizer(block)
        isUserInteractionEnabled = true
    }

    public func addSwipeUpGesture(action: EmptyClosure?) {
        let block = BlockSwipe(action: action)
        block.direction = .up
        addGestureRecognizer(block)
        isUserInteractionEnabled = true
    }

    public func addSwipeRightGesture(action: EmptyClosure?) {
        let block = BlockSwipe(action: action)
        block.direction = .right
        addGestureRecognizer(block)
        isUserInteractionEnabled = true
    }

    @discardableResult
    public func addMenuButtonTap(action: EmptyClosure?) -> UITapGestureRecognizer {
        let gesture = BlockTap(action: action, menuButton: true)
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
        return gesture
    }
}

public final class BlockTap: UITapGestureRecognizer {
    private var tapAction: EmptyClosure?

    override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init(action: EmptyClosure?, menuButton: Bool = false) {
        self.init()
        self.tapAction = action
        self.addTarget(self, action: #selector(didTap(_:)))
        self.cancelsTouchesInView = false
        if menuButton {
            self.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        }
    }

    @objc
    private func didTap(_ tap: UITapGestureRecognizer) {
        tapAction?()
    }
}

public final class BlockSwipe: UISwipeGestureRecognizer {
    private var tapAction: EmptyClosure?

    override public init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init(action: EmptyClosure?) {
        self.init()
        self.tapAction = action
        self.cancelsTouchesInView = false
        self.addTarget(self, action: #selector(didTap(_:)))
    }

    @objc
    private func didTap(_ tap: UITapGestureRecognizer) {
        tapAction?()
    }
}

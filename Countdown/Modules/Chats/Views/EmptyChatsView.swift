import UIKit

class EmptyChatsView: UIView {
    private let tapHandler: () -> Void
    
    private let titleLabel = UIView.boldLabel("No chats yet", fontSize: 18, textColor: .white)
    private let subtitleLabel = UIView.systemLabel("Find someone to write to", fontSize: 14, textColor: .init(hex: 0x6C7275))
    
    private lazy var button: UIButton = {
        let button = CandyButton { [weak self] in
            self?.tapHandler()
        }.setupTitle("Select").setupTextColor(.black).setupFont(.systemFont(ofSize: 18, weight: .medium)).height(56).width(300).cornerRadius(16, clipsToBounds: true).setupImage("starts")
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
            button.addContentInset(10)
        }
        return button
    }()
    
    init(tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView(axis: .vertical, views: [
            titleLabel,
            .padding(height: 8),
            subtitleLabel,
            .padding(height: 24),
            button
        ]).alignment(.center)
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

class CandyView: UIView {
    private var gradien: CALayer?
    
    init() {
        super.init(frame: .zero)
        gradien = applyGradient(colours: [.init(hex: 0xFF684C), .init(hex: 0xFF76D7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradien != nil, gradien?.isHidden == false {
            gradien?.removeFromSuperlayer()
            gradien = applyGradient(colours: [.init(hex: 0xFF684C), .init(hex: 0xFF76D7)])
        }
    }
    
    func hideGradien() {
        gradien?.isHidden = true
    }
    
    func showGradient() {
        gradien?.isHidden = false
        
        if gradien?.bounds == .zero {
            gradien = applyGradient(colours: [.init(hex: 0xFF684C), .init(hex: 0xFF76D7)])
        }
    }
}

class CandyButton: CustomButton {
    private var gradien: CALayer?
    
    override init(tapHandler: @escaping () -> Void) {
        super.init(tapHandler: tapHandler)
        gradien = applyGradient(colours: [.init(hex: 0xFF684C), .init(hex: 0xFF76D7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradien?.frame = bounds
    }
}

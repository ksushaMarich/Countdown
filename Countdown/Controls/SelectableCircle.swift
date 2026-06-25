
import UIKit

class SelectableCircle: UIControl {
    
    // MARK: - Naming
    
    private let circleSize = CGFloat.proportionalToDesignHeight(22)
    
    private let centerCircleSize = CGFloat.proportionalToDesignHeight(8)
    
    override var isSelected: Bool {
        didSet {
            updateSelectionState(animated: true)
        }
    }
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = circleSize / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.selectableCircleGray.cgColor
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var selectedCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = circleSize / 2
        view.backgroundColor = .themeRed
        view.isUserInteractionEnabled = false
        view.alpha = 0
        return view
    }()
    
    private lazy var selectedCenterCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = centerCircleSize/2
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSelectionState(animated: Bool) {
        let targetAlpha: CGFloat = isSelected ? 1 : 0
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.selectedCircleView.alpha = targetAlpha
            }
        } else {
            selectedCircleView.alpha = targetAlpha
        }
    }
    
    private func setup() {
        addSubview(circleView)
        addSubview(selectedCircleView)
        selectedCircleView.addSubview(selectedCenterCircleView)
        
        circleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(circleSize)
        }
        
        selectedCircleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(circleSize)
        }
        
        selectedCenterCircleView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(centerCircleSize)
        }
    }
    
    @objc private func handleTap() {
        isSelected.toggle()
        sendActions(for: .valueChanged)
    }
}

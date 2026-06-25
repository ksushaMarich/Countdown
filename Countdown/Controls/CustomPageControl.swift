
import UIKit

class CustomPageControl: UIControl {

    //MARK: - Naming
    
    private var indicatorView: UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6.5
        view.backgroundColor = .black
        return view
    }

    private lazy var leftIndicator = indicatorView
    
    private lazy var rightIndicator = indicatorView
    
    private lazy var indicatorsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [leftIndicator, rightIndicator])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alpha = 0.2
        return stackView
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rightIndicator.alpha = 0.4
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func updateCurrentPage(scrollPercentage: Double) {
        guard scrollPercentage >= 0 && scrollPercentage <= 1 else { return }
        
        leftIndicator.snp.updateConstraints { make in
            make.width.equalTo(13 + 26 * scrollPercentage)
        }
    }
    
    private func setupUI() {
        addSubview(indicatorsStackView)
        
        indicatorsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(13)
            make.width.equalTo(60)
        }
        
        leftIndicator.snp.makeConstraints { make in
            make.width.equalTo(13)
        }
    }
}

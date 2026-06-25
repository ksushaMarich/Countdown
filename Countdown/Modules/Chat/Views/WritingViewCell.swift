import Lottie
import SnapKit

class WritingViewCell: UITableViewCell {
    static let reuseIdentifier = "WritingViewCell"
    
    private lazy var lottieView: LottieAnimationView = {
        let view = LottieAnimationView(name: "writing", bundle: .main)
        view.loopMode = .loop
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .init(hex: 0x141718)
        
        let stackView = UIView.leftStackView(views: [lottieView])
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        lottieView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }
        
        if lottieView.isAnimationPlaying == false {
            lottieView.play()
        }
    }
}

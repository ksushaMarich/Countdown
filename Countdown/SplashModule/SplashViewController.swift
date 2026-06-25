
import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    
    // MARK: Naming
    
    var presenter: SplashViewOutput?
    
    private lazy var circleViewSize = 45
    
    private lazy var launchImage = UIImageView(image: .launch)
    
    private lazy var topCircleImageView = UIImageView()
    
    private lazy var trailingCircleImageView: UIImageView = {
        let view = UIImageView()
        view.image = .trailingCircle
        view.alpha = 0
        return view
    }()
    
    private lazy var bottomCircleImageView: UIImageView = {
        let view = UIImageView()
        view.image = .bottomCircle
        view.alpha = 0
        return view
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupView()
    }
    
    //MARK: - Methods
    
    private func setupView() {
        
        view.backgroundColor = .launchBackground
        
        view.addSubview(launchImage)
        launchImage.addSubview(trailingCircleImageView)
        launchImage.addSubview(bottomCircleImageView)
        
        launchImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-28)
            make.width.equalTo(161)
            make.height.equalTo(161)
        }
        
        trailingCircleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomCircleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SplashViewController: SplashViewInput {
    func animateCircles() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.5,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
            self?.trailingCircleImageView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3,
                           delay: 0.5,
                           options: [.curveEaseInOut],
                           animations: { [weak self] in
                self?.bottomCircleImageView.alpha = 1
            }) { [weak self] _ in
                self?.presenter?.animationСompleted()
            }
        }
    }
}

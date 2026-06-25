
import UIKit
import SnapKit

final class EmptinessView: UIView {
    
    //MARK: - Life cycle
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
       
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupView() {
        let lineView = UIView()
        lineView.backgroundColor = .black
        backgroundColor = .emptinessGray
        addSubview(lineView)
           
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        lineView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(1.5)
        }
           
        lineView.transform = CGAffineTransform(rotationAngle: -.pi/4 )
    }
}

import UIKit

class DoneView: UIView {
    lazy var finishView = UIView.imageView(imageName)
   
    private let imageName: String
    private lazy var doneView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.9)
        view.addSubview(finishView)
        finishView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    init(imageName: String) {
        self.imageName = imageName
        super.init(frame: .zero)
        setupView()
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(doneView)
        doneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


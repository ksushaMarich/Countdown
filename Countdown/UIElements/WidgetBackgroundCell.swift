
import UIKit

final class WidgetBackgroundCell: UICollectionViewCell {
    
    //MARK: - Naming
    
    static var identifier = "WidgetBackgroundCell"
    
    private lazy var view = UIView()
    
    private lazy var selectionCircleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = bounds.width / 2.0
        view.layer.borderWidth = 1.0
        return view
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionCircleView.layer.borderColor =  UIColor.clear.cgColor
        selectionCircleView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    //MARK: - Methods
    
    private func setupView() {
        contentView.addSubview(selectionCircleView)
        
        selectionCircleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with view: UIView, isSelected: Bool, selectionCircleOffset: CGFloat = 3) {
        
        selectionCircleView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(selectionCircleOffset)
            make.centerX.centerY.equalToSuperview()
        }

        selectionCircleView.layoutIfNeeded()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.bounds.height / 2
        
        selectionCircleView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
}

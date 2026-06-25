
import UIKit
import SnapKit

protocol ChooseWidgetBackgroundControlDelegate: AnyObject {
    func newItemSelected(at index: Int, for type: ChooseWidgetBackgroundControlType)
}

final class ChooseWidgetBackgroundControl: UIControl {
    
    //MARK: - Naming
    
    weak var delegate: ChooseWidgetBackgroundControlDelegate?
    
    private var type: ChooseWidgetBackgroundControlType
    
    private var backgroundViews: [UIView?]
    
    private var selectedIndex: Int
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .searchBarBlack
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CalendarFlowLayout(inset: 10, scrollDirection: .horizontal, leadingInset: 16))
        collectionView.register(WidgetBackgroundCell.self, forCellWithReuseIdentifier: WidgetBackgroundCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: - Life cycle
    
    init(title: String, views: [UIView?], selectedIndex: Int, type: ChooseWidgetBackgroundControlType) {
        self.type = type
        backgroundViews = views
        self.selectedIndex = selectedIndex
        super.init(frame: .zero)
        self.titleLabel.text = title
        backgroundColor = .white
        setupUI()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setSelectedIndex(_ index: Int) {
        guard selectedIndex != index else { return }
        selectedIndex = index
        collectionView.reloadData()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(14))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(24))
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(8))
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(1)
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).offset(CGFloat.proportionalToDesignHeight(8))
            make.height.equalTo(CGFloat.proportionalToDesignHeight(CGFloat.proportionalToDesignHeight(50)))
        }
    }
    
    private func setupLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = 14
        layer.borderColor = UIColor.themeRed.withAlphaComponent(0.2).cgColor
        layer.borderWidth = 1
    }
}

extension ChooseWidgetBackgroundControl: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        backgroundViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetBackgroundCell.identifier, for: indexPath) as? WidgetBackgroundCell else { return UICollectionViewCell() }
        let isSelected = indexPath.row == selectedIndex
        if let backgroundView = backgroundViews[indexPath.row] {
            cell.configure(with: backgroundView, isSelected: isSelected)
        } else {
            cell.configure(with: EmptinessView(), isSelected: isSelected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.newItemSelected(at: indexPath.row, for: type)
    }
}

extension ChooseWidgetBackgroundControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat.proportionalToDesignHeight(38), height: CGFloat.proportionalToDesignHeight(38))
    }
}

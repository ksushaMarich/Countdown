
import UIKit
import SnapKit

final class CustomCategoryViewController: UIViewController {

    //MARK: - Naming

    var presenter: CustomCategoryViewOutput?
    
    private lazy var sheetHeight: CGFloat = presenter?.getVisibleContentHeight() ?? 0
    
    private var sheetBottomConstraint: Constraint?

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped)))
        return view
    }()

    private lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var grabberContainerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2.5
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    private lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .grabber.withAlphaComponent(0.8)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2.5
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new category"
        label.font = InterFont.medium.of(size: 24)
        return label
    }()
    
    private lazy var addCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Add"
        label.font = InterFont.medium.of(size: 20)
        label.textAlignment = .right
        label.textColor = .themeRed
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCategoryLabelTapped)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = PaddedTextField(textInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        textField.font = InterFont.regular.of(size: 20)
        textField.textColor = UIColor.searchBarBlack
        textField.attributedPlaceholder =  NSAttributedString(
            string: "New category",
            attributes: [
                .font: InterFont.regular.of(size: 20),
                .foregroundColor: UIColor.searchBarBlack
            ]
        )
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.themeRed.withAlphaComponent(0.2).cgColor
        return textField
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Color badge"
        label.font = InterFont.regular.of(size: 20)
        return label
    }()
    
    private lazy var colectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 7
        flowLayout.minimumLineSpacing = 7
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 20, right: 10)
        return flowLayout
    }()
    
    private lazy var colectionView: UICollectionView = {
        let colectionView = UICollectionView(frame: .zero, collectionViewLayout: colectionViewFlowLayout)
        colectionView.layer.borderColor = UIColor.themeRed.withAlphaComponent(0.2).cgColor
        colectionView.layer.cornerRadius = 8
        colectionView.layer.borderWidth = 1
        colectionView.delegate = self
        colectionView.dataSource = self
        colectionView.register(WidgetBackgroundCell.self, forCellWithReuseIdentifier: WidgetBackgroundCell.identifier)
        colectionView.showsVerticalScrollIndicator = false
        return colectionView
    }()

    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isUserInteractionEnabled = false
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentSheet()
        categoryNameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }

    //MARK: - Methods

    private func setupView() {
        
        view.backgroundColor = .clear

        view.addSubview(dimmedView)
        view.addSubview(sheetView)
        sheetView.addSubview(grabberContainerView)
        grabberContainerView.addSubview(grabberView)
        sheetView.addSubview(titleLabel)
        sheetView.addSubview(addCategoryLabel)
        sheetView.addSubview(categoryNameTextField)
        sheetView.addSubview(colorTitleLabel)
        sheetView.addSubview(colectionView)

        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sheetView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(sheetHeight)
            self.sheetBottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(sheetHeight).constraint
        }
        
        grabberContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(49)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(40))
        }
        
        grabberView.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(10))
            make.height.equalTo(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(40))
            make.leading.equalToSuperview().offset(20)
        }
        
        addCategoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        categoryNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(24))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(52)
        }
        
        colorTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryNameTextField.snp.bottom).offset(CGFloat.proportionalToDesignHeight(24))
            make.leading.equalTo(24)
        }
        
        colectionView.snp.makeConstraints { make in
            make.top.equalTo(colorTitleLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(8))
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(CGFloat.proportionalToDesignHeight(186))
        }
    }

    private func presentSheet() {
        sheetBottomConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translationY = gesture.translation(in: view).y
           
           switch gesture.state {
           case .changed:
           if translationY > 0 {
               sheetBottomConstraint?.update(offset: translationY)
               let progress = min(1, translationY / sheetHeight)
               dimmedView.alpha = 1 - progress
               view.layoutIfNeeded()
           }
               
           case .ended:
           if translationY > 100 {
               sheetBottomConstraint?.update(offset: sheetHeight)
               self.view.endEditing(true)
               UIView.animate(withDuration: 0.3, animations: {
                   self.dimmedView.alpha = 0
                   self.view.layoutIfNeeded()
               }, completion: { _ in
                   self.dismiss(animated: false)
               })
           } else {
               sheetBottomConstraint?.update(offset: 0)
               UIView.animate(withDuration: 0.3) {
                   self.dimmedView.alpha = 1
                   self.view.layoutIfNeeded()
               }
           }
               
           default:
               break
           }
    }

    @objc private func dimmedViewTapped() {
        
        sheetBottomConstraint?.update(offset: sheetHeight)
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
    
    @objc func addCategoryLabelTapped() {
        presenter?.saveNewCategory()
        dimmedViewTapped()
    }
}

extension CustomCategoryViewController: CustomCategoryViewInput {
    func giveCategoryName() -> String? {
        categoryNameTextField.text
    }
}

extension CustomCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let colors = presenter?.colors else { return 0 }
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetBackgroundCell.identifier, for: indexPath) as? WidgetBackgroundCell else { return UICollectionViewCell() }
        let isSelected = indexPath.row == presenter?.indexOfSelectedColor
        if let color = presenter?.colors[indexPath.row] {
            let view = UIView()
            view.backgroundColor = color
            cell.configure(with: view, isSelected: isSelected, selectionCircleOffset: 4)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.updateIndexOfSelectedColor(indexPath.row)
        collectionView.reloadData()
    }
}

extension CustomCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let rows: CGFloat = 3
        let itemsInRow: CGFloat = 5
        
        let insets = flow.sectionInset
        
        let availableWidth = collectionView.bounds.width - insets.left - insets.right
        let availableHeight = collectionView.bounds.height - insets.top - insets.bottom
        
        let maxWidthCell = floor(availableWidth / itemsInRow)
        let maxHeightCell = floor(availableHeight / rows)
        
        let side = min(maxWidthCell, maxHeightCell)
        
        let horizontalSpacing = (availableWidth - side * itemsInRow) / (itemsInRow - 1)
        flow.minimumInteritemSpacing = horizontalSpacing
        
        let verticalSpacing = (availableHeight - side * rows) / (rows - 1)
        flow.minimumLineSpacing = verticalSpacing
        
        return CGSize(width: side, height: side)
    }
}

extension CustomCategoryViewController: UIGestureRecognizerDelegate {}


import SnapKit
import UIKit

class PartialModalViewController: UIViewController {

    //MARK: - Naming

    private lazy var sheetHeight: CGFloat = getVisibleContentHeight()
    
    private var sheetBottomConstraint: Constraint?

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped)))
        return view
    }()

    lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 24
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
    
    lazy var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .grabber.withAlphaComponent(0.8)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2.5
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentSheet()
    }
    
    func getVisibleContentHeight() -> CGFloat {
        return view.bounds.height
    }
    
    private func setupView() {
        
        view.backgroundColor = .clear

        view.addSubview(dimmedView)
        view.addSubview(sheetView)
        sheetView.addSubview(grabberContainerView)
        grabberContainerView.addSubview(grabberView)

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
        dimmedViewTapped()
    }
}

extension PartialModalViewController: UIGestureRecognizerDelegate {}

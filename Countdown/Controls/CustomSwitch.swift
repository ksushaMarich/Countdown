
import UIKit
import SnapKit

class CustomSwitch: UIControl {

    //MARK: - Naming
    
    private var isOn: Bool = false {
       didSet {
           updateAppearance(isOn: isOn)
           if oldValue != isOn {
               sendActions(for: .valueChanged)
           }
       }
    }
    
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .switchGray
        view.layer.cornerRadius = 13
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let knobView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.isUserInteractionEnabled = true
        return view
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGestureRecognizer()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setOn(_ on: Bool, animated: Bool) {
        isOn = on
    }
   
    func getState() -> Bool {
        return isOn
    }
    
    private func setupUI() {
        addSubview(trackView)
        addSubview(knobView)
        
        trackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        knobView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(3)
            make.width.equalTo(knobView.snp.height)
            make.leading.equalToSuperview().inset(3)
        }
    }
      
    private func addGestureRecognizer() {
        trackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSwitch)))
        knobView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSwitch)))
    }
       
    private func updateAppearance(isOn: Bool) {
       
        if isOn {
            UIView.animate(withDuration: 0.25) {
                self.knobView.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview().inset(3)
                    make.width.equalTo(self.knobView.snp.height)
                    make.trailing.equalToSuperview().inset(3)
                }
                self.trackView.backgroundColor = UIColor.themeRed
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.knobView.snp.remakeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview().inset(3)
                    make.width.equalTo(self.knobView.snp.height)
                    make.leading.equalToSuperview().inset(3)
                }
                self.trackView.backgroundColor = UIColor.switchGray
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc private func toggleSwitch() {
       isOn.toggle()
    }
}

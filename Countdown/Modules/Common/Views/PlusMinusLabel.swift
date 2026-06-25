import UIKit


class PlusMinusLabel: UIView {
    private let handler: (Int) -> Void
    private var value = 20 {
        didSet {
            label.text = value.string
            handler(value)
        }
    }
    
    private lazy var label = UIView.label(value.string)
        .font(.monospacedDigitSystemFont(ofSize: 20, weight: .bold))
        .textColor(.init(hex: 0xFFE660))
    
    private lazy var minusButton = UIView.button {
        if self.value > 10 {
            self.value -= 1
        }
    }.setupImage("minus")
    
    private lazy var plusButton = UIView.button {
        self.value += 1
    }.setupImage("plus")
    
    init(handler: @escaping (Int) -> Void) {
        self.handler = handler
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let st = UIView.horizontalStackView(views: [
            minusButton,
            label,
            plusButton
        ]).spacing(10).alignment(.center)
        
        addSubview(st)
        st.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

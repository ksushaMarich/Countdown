
import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Naming
    
    static var identifier = "CalendarCollectionViewCell"
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 18)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        setupCell()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        backgroundColor = .clear
    }
    
    //MARK: - Methods
    
    func setupLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 1
    }
    
    private func setupCell() {
        contentView.addSubview(dayLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with day: Int, isSelectedMonth: Bool, isSelectedDay: Bool, isCurrentDay: Bool) {
        dayLabel.text = String(day)
        dayLabel.textColor = isSelectedMonth ? .black : .grayFont
        layer.borderColor = isCurrentDay && isSelectedMonth ? UIColor.themeRed.cgColor : UIColor.clear.cgColor
        if isSelectedMonth {
            backgroundColor = isSelectedDay ? .themeRed : .clear
            if isSelectedDay {
                dayLabel.textColor = .white
            } else {
                dayLabel.textColor = .blackFont
            }
        }
    }
}

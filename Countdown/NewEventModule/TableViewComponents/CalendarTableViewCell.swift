
import UIKit
import SnapKit

protocol CalendarTableViewCellDelegate: AnyObject {
    func dateСhanged(_ newData: Date?)
}

final class CalendarTableViewCell: RoundedTableViewCell {
    
    //MARK: - Naming
    
    static let identifier = "CalendarTableViewCell"
    
    weak var delegate: CalendarTableViewCellDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .blackFont
        label.text = "Date"
        return label
    }()
    
    private lazy var daysLeftLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .grayFont
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var calendar: CalendarControl = {
        let calendar = CalendarControl()
        calendar.delegate = self
        return calendar
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        calendar.isUserInteractionEnabled = true    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configure(with date: Date) {
        super.configure(position: nil)
        calendar.setSelectedDate(with: date)
    }
    
    func getCellHeight() -> CGFloat {
        return 14 + 24 + 14 + 1 + calendar.getSizeToHeight()
    }
    
    private func setupCell() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(daysLeftLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(calendar)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(45)
            make.height.equalTo(24)
        }
        
        daysLeftLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-17)
            make.height.equalTo(24)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setDaysLeftLabelText(with days: Int) {
        daysLeftLabel.text = "\(days) \(days == 1 ? "day" : "days") left"
    }
}

extension CalendarTableViewCell: CalendarControlProtocol {
    func dateСhanged(_ newData: Date?) {
        delegate?.dateСhanged(newData)
    }
}


import UIKit
import EventKit

protocol ImportEventTableViewCellDelegate: AnyObject {
    func setNewValue(for indexPath: IndexPath, with value: Bool)
}

class ImportEventTableViewCell: RoundedTableViewCell {
    
    //MARK: - Naming

    static let identifier = "ImportEventTableViewCell"
    
    weak var delegate: ImportEventTableViewCellDelegate?
    
    private var indexPath: IndexPath?
    
    private lazy var leadingInset = CGFloat.proportionalToDesignWidth(20)
    
    private lazy var labelWidth = CGFloat.proportionalToDesignWidth(268)
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.medium.of(size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .searchBarBlack
        return label
    }()
    
    private lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 16)
        label.textColor = .grayFont
        return label
    }()
    
    private lazy var selectableCircle: SelectableCircle = {
        let circle = SelectableCircle()
        circle.addTarget(self, action: #selector(selectableCircleValueChanged), for: .valueChanged)
        return circle
    }()

    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        selectableCircle.isSelected = false
    }
    
    //MARK: - Methods
    
    func configure(position: CellPosition? = nil, indexPath: IndexPath, event: SelectableEvent) {
        super.configure(position: position)
        self.indexPath = indexPath
        eventNameLabel.text = event.event.title
        self.selectableCircle.isSelected = event.isSelected
        self.eventDateLabel.text = event.event.formattedStartDate()
    }
    
    func configure(isSelected: Bool) {
        self.selectableCircle.isSelected = isSelected
    }
    
    private func setup() {
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(selectableCircle)
        contentView.addSubview(eventDateLabel)
        
        eventNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(leadingInset)
            make.height.equalTo(CGFloat.proportionalToDesignWidth(24))
            make.width.equalTo(labelWidth)
        }
        
        selectableCircle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(-18))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        eventDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingInset)
            make.top.equalTo(eventNameLabel.snp.bottom).offset(CGFloat.proportionalToDesignHeight(4))
            make.height.equalTo(CGFloat.proportionalToDesignWidth(24))
            make.width.equalTo(labelWidth)
        }
    }
    
    @objc private func selectableCircleValueChanged() {
        guard let indexPath else { return }
        delegate?.setNewValue(for: indexPath, with: selectableCircle.isSelected)
    }
}

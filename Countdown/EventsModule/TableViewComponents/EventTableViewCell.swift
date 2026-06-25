
import UIKit
import SnapKit

protocol EventTableViewCellDelegate: AnyObject {
    func deleteCell(with event: Event)
    func deleteViewIsViewOpened(for indexPath: IndexPath)
}

class EventTableViewCell: RoundedTableViewCell {
    
    // MARK: - Naming
    
    static let identifier = "EventTableViewCell"
    
    weak var delegate: EventTableViewCellDelegate?
    
    private(set) var isDeleteViewOpened = false {
        didSet {
            if isDeleteViewOpened, let indexPath {
                delegate?.deleteViewIsViewOpened(for: indexPath)
            }
        }
    }
    
    private var event: Event?
    private(set) var indexPath: IndexPath?
    
    private lazy var leadingInset = CGFloat.proportionalToDesignWidth(20)
    private lazy var eventColorViewSize = 6
    
    private lazy var containerView = UIView()
    
    private lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .trashBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteCell)))
        return view
    }()
    
    private lazy var deleteImageView = UIImageView(image: .trashCan)
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.medium.of(size: 20)
        label.textColor = .blackFont
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var daysLeftLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 16)
        label.textColor = .grayFont
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [eventNameLabel, daysLeftLabel])
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 16)
        label.textColor = .grayFont
        return label
    }()
    
    private lazy var eventCategoryView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 9
        view.backgroundColor = UIColor.eventCategoryBackground
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private lazy var eventColorView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(eventColorViewSize/2)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }()
    
    private lazy var eventCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.medium.of(size: 10)
        label.textColor = .black
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addPanGestureRecognizer()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        eventNameLabel.text = nil
        daysLeftLabel.text = nil
        dateLabel.text = nil
        eventCategoryLabel.text = nil
        
        eventColorView.backgroundColor = nil
        
        deleteView.snp.updateConstraints { make in
            make.width.equalTo(0)
        }
        layoutIfNeeded()
    }
    
    func configure(with event: Event, for indexPath: IndexPath, position: CellPosition? = nil) {
        
        super.configure(position: position)
        self.event = event
        self.indexPath = indexPath
        if let position {
            cellPosition = position
        }
        
        if cellPosition == .bottom || position == .single {
           separatorView.backgroundColor = .clear
        } else {
            separatorView.backgroundColor = .themeRed.withAlphaComponent(0.2)
        }
        
        eventNameLabel.text = event.name
        if let daysLeft = event.daysLeft {
            daysLeftLabel.text = event.daysLeft == 1 ? "\(daysLeft) day left" : "\(daysLeft) days left"
            dateLabel.text = DateComponentsBuilder.makeString(for: event.date, time: event.time, isAllDay: event.isAllDay)
            eventCategoryLabel.text = event.category
            let color: UIColor
            
            switch event.category {
            case "Imported":
                color = .black
            default:
                let index = EventOptionsType.category.getOptions().firstIndex(where: { $0 == event.category })
                let colors = EventOptionsType.category.getColors()
                if let colors, let index {
                    color = colors[index]
                } else {
                    color = .black
                }
            }
            eventColorView.backgroundColor = color
        }
    }
    
    func closeDeleteView() {
        isDeleteViewOpened = false
        UIView.animate(withDuration: 0.3) { [weak self] in
                self?.deleteView.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            self?.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        
        contentView.addSubview(deleteView)
        deleteView.addSubview(deleteImageView)
        
        containerView.addSubview(topStackView)
        containerView.addSubview(dateLabel)
        
        containerView.addSubview(eventCategoryView)
        eventCategoryView.addSubview(eventColorView)
        eventCategoryView.addSubview(eventCategoryLabel)
        
        contentView.addSubview(separatorView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.trailing.equalTo(deleteView.snp.leading)
            make.width.equalToSuperview()
        }
        
        deleteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(26)
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.leading.equalTo(leadingInset)
            make.trailing.equalTo(-leadingInset)
            make.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(leadingInset)
            make.top.equalTo(topStackView.snp.bottom).offset(4)
            make.height.equalTo(24)
        }
        
        eventCategoryView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(leadingInset)
            make.height.equalTo(18)
        }
        
        eventColorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(eventColorViewSize)
        }
        
        eventCategoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(eventColorView.snp.trailing).offset(6)
            make.height.equalTo(12)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(leadingInset)
            make.height.equalTo(1)
        }
    }
    
    private func addPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: contentView)
        
        switch gesture.state {
        case .changed:
        deleteView.snp.updateConstraints { make in
            make.width.equalTo( isDeleteViewOpened ? max(0, 60-translation.x) : max(0, -translation.x))
        }
        layoutIfNeeded()
        case .ended:
        UIView.animate(withDuration: 0.3) { [weak self] in
            let width: Int
            
            if translation.x > 0 {
                width = 0
                self?.isDeleteViewOpened = false
            } else if translation.x > -200 {
                width = 60
                self?.isDeleteViewOpened = true
            } else {
                width = 0
                self?.isDeleteViewOpened = true
                guard let event = self?.event else { return }
                self?.delegate?.deleteCell(with: event)
            }
            
            self?.deleteView.snp.updateConstraints { make in
                make.width.equalTo(width)
            }
            self?.layoutIfNeeded()
        }
        default:
            break
        }
    }
    
    @objc private func deleteCell() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.deleteView.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            guard let event else { return }
            self.delegate?.deleteCell(with: event)
        }
    }
}

extension EventTableViewCell {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        super.gestureRecognizerShouldBegin(gestureRecognizer)
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }

        let velocity = panGesture.velocity(in: self)
        return abs(velocity.x) > abs(velocity.y)
    }
}

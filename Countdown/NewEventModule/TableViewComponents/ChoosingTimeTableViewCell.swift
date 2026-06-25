
import UIKit
import SnapKit

protocol ChoosingTimeTableViewCellDelegate: AnyObject {
    func modeDidChange(isTimeModeOn: Bool)
    func timeTextFieldIsSelected()
    func timeDidChange(hours: Int, minutes: Int)
}

final class ChoosingTimeTableViewCell: RoundedTableViewCell {

    //MARK: - Naming
    
    static let identifier = "ChoosingTimeTableViewCell"
    
    weak var delegate: ChoosingTimeTableViewCellDelegate?
    
    private(set) lazy var isTimeModeOn = timeSwitch.getState() {
        didSet {
            setupUIBasedOnMode()
            delegate?.modeDidChange(isTimeModeOn: isTimeModeOn)
            if !isTimeModeOn {
                timePicker.text = ""
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .blackFont
        return label
    }()
    
    private lazy var timeSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.addTarget(self, action: #selector(toggleTimeMode), for: .valueChanged)
        return customSwitch
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var timePicker: TimeTextField = {
        let picker = TimeTextField()
        picker.listener = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = InterFont.regular.of(size: 10)
        label.textColor = .grayFont
        label.text = "Setting a date earlier than the current one is not allowed"
        return label
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configure(time: EventTime?) {
        super.configure(position: nil)
        guard let time else { return }
        timeSwitch.setOn(true, animated: false)
        timePicker.setupTime(time: time)
    }
    
    func manageHintDisplay(for date: Date) {
        guard isTimeModeOn else {
            self.setNormalStyle()
            return
        }
        
        if date < Date() {
            self.setErrorStyle()
        } else {
            self.setNormalStyle()
        }
    }
    
    func setupCell() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeSwitch)
        setupUIBasedOnMode()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(20)
        }
        
        timeSwitch.snp.makeConstraints { make in
            make.top.equalTo(13)
            make.trailing.equalToSuperview().offset(-13)
            make.height.equalTo(26)
            make.width.equalTo(48)
        }
    }
    
    private func setupUIBasedOnMode() {
        if !isTimeModeOn {
            separatorView.removeFromSuperview()
            timePicker.removeFromSuperview()
            hintLabel.removeFromSuperview()
        } else {
            contentView.addSubview(separatorView)
            contentView.addSubview(timePicker)
            contentView.addSubview(hintLabel)
            
            separatorView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(13)
                make.centerX.equalToSuperview()
                make.leading.equalToSuperview().offset(20)
                make.height.equalTo(1)
            }
            
            timePicker.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.top.equalTo(separatorView.snp.bottom).offset(CGFloat.proportionalToDesignHeight(12))
                make.width.equalTo(100)
                make.height.equalTo(CGFloat.proportionalToDesignHeight(24))
            }
            
            hintLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.centerX.equalToSuperview()
                make.top.equalTo(timePicker.snp.bottom)
                make.height.equalTo(CGFloat.proportionalToDesignHeight(28))
            }
        }
    }
    
    @objc private func toggleTimeMode() {
        isTimeModeOn.toggle()
    }
}

extension ChoosingTimeTableViewCell: TimeTextFieldListener {
    func timePickerDidChange(hours: Int, minutes: Int) {
        delegate?.timeDidChange(hours: hours, minutes: minutes)
    }
    
    func timePickerDidSelectTextField() {
        delegate?.timeTextFieldIsSelected()
    }
}

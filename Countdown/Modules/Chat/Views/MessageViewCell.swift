import UIKit
import SnapKit

class MessageViewCell: UITableViewCell {
    static let reuseIdentifier = "MessageViewCell"
    
    private lazy var containerView: CandyView = {
        let view = CandyView()
        view.cornerRadius(18, clipsToBounds: true)
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with messageModel: MessageModelViewModel) {
        messageLabel.text = messageModel.text
        timeLabel.text = messageModel.date.formate("hh:mm")
        
        if messageModel.isUserMessage {
            containerView.hideGradien()
            containerView.backgroundColor(.init(hex: 0x343839))
            timeLabel.textColor = .init(hex: 0x9C9CA3)
        } else {
            containerView.showGradient()
            containerView.backgroundColor(.clear)
            timeLabel.textColor = .white
        }
        
        updateLayout(isUserMessage: messageModel.isUserMessage)
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .init(hex: 0x141718)
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(6)
        }
        
        containerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(6)
        }
    }
    
    private func updateLayout(isUserMessage: Bool) {
        if isUserMessage {
            updateLayoutForUserMessage()
        } else {
            updateLayoutForNonUserMessage()
        }
    }
    
    private func updateLayoutForUserMessage() {
        containerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.greaterThanOrEqualToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(6)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(6)
            make.top.equalTo(messageLabel.snp.bottom).inset(-4)
        }
    }
    
    private func updateLayoutForNonUserMessage() {
        containerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
            make.leading.equalToSuperview().inset(8)
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(6)
            make.width.equalTo(40)
            make.leading.equalTo(messageLabel.snp.trailing).inset(-12)
        }
    }
}

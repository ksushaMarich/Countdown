import Lottie
import SnapKit

struct ChatViewModel {
    let avatarUrl: URL?
    let name: String
    let lastMessage: String
    let date: String
}

class ChatViewCell: UITableViewCell {
    static let reuseIdentifier = "ChatViewCell"
    
    private lazy var avatarImageView: UIImageView = .imageView("").contentMode(.scaleAspectFill).size(60).cornerRadius(30, clipsToBounds: true).backgroundColor(.init(hex: 0x232627))
    private lazy var nameLabel = UIView.boldLabel("", fontSize: 16, textColor: .white).numberOfLines(1)
    private lazy var lastMessageLabel = UIView.systemLabel("", fontSize: 14, textColor: .init(hex: 0x6C7275)).numberOfLines(2)
    private lazy var dateLabel = UIView.systemLabel("", fontSize: 14, textColor: .init(hex: 0x6C7275))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ChatViewModel) {
//        avatarImageView.set(url: viewModel.avatarUrl)
        nameLabel.text = viewModel.name
        lastMessageLabel.text = viewModel.lastMessage
        dateLabel.text = viewModel.date
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .init(hex: 0x141718)
        
        dateLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        
        let stackView = UIView.horizontalStackView(views: [
            avatarImageView,
            .verticalStackView(views: [
                nameLabel,
                lastMessageLabel
            ]).spacing(4),
            dateLabel,
        ]).spacing(12).alignment(.center).contentInset(.init(horizontal: 12, vertical: 0))
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
}

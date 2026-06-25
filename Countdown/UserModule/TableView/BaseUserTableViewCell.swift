
import UIKit

class BaseUserTableViewCell: RoundedTableViewCell {

    //MARK: - Naming
    
    static let identifier = "BaseUserTableViewCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = InterFont.regular.of(size: 16)
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .themeRed
        return imageView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeRed.withAlphaComponent(0.2)
        return view
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        contentView.addSubview(label)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separatorView)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset( CGFloat.proportionalToDesignWidth(16))
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(-16))
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(14))
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(16))
            make.height.equalTo(1)
        }
    }
    
    func configure(with text: String, position: CellPosition) {
        super.configure(position: position)
        self.label.text = text
        
        if cellPosition == .bottom || position == .single {
           separatorView.backgroundColor = .clear
        } else {
            separatorView.backgroundColor = .themeRed.withAlphaComponent(0.2)
        }
        
    }
}

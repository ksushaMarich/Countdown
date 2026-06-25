
import UIKit
import SnapKit

class EventSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Naming
    
    static let identifier = "EventSectionHeaderView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .grayFont
        return label
    }()
    
    // MARK: - Life cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

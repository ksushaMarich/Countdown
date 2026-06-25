
import UIKit

class YearPickerTableViewCell: UITableViewCell {
    
    // MARK: - Naming
    
    static var identifier = "YearPickerTableViewCell"
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 20)
        return label
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: .checkmarkYear)
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkImageView.alpha = 0
    }
    
    // MARK: - Methods
    
    func configure(with year: Int, isSelected: Bool) {
        yearLabel.text = String(year)
        if isSelected {
            checkmarkImageView.alpha = 1
        } else {
            checkmarkImageView.alpha = 0
        }
    }
    
    private func setupCell() {
        contentView.addSubview(yearLabel)
        yearLabel.addSubview(checkmarkImageView)
        
        yearLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(14)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(2)
            make.width.height.equalTo(22)
        }
    }
}

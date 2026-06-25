
import UIKit

class DropdownTableViewCell: UITableViewCell {

    //MARK: - Naming
    
    static let identifier = "DropdownTableViewCell"
    
    private let color: UIColor? = nil
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = InterFont.regular.of(size: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var colorCategoryView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    private lazy var checkmarkImageView = UIImageView(image: .navigationItemSave)
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configure(with text: String, color: UIColor?, isSelected: Bool) {
        
        label.text = text
        contentView.addSubview(label)
        
        if isSelected {
            contentView.addSubview(checkmarkImageView)
            
            checkmarkImageView.snp.makeConstraints { make in
                make.top.equalTo(label)
                make.trailing.equalToSuperview().offset(-14)
                make.width.height.equalTo(22)
            }
        } else {
            checkmarkImageView.removeFromSuperview()
        }
        
        if let color {
            colorCategoryView.backgroundColor = color
            contentView.addSubview(colorCategoryView)
            
            colorCategoryView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.leading.equalToSuperview().offset(14)
                make.width.height.equalTo(6)
            }
            
            label.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(5)
                make.bottom.equalToSuperview().offset(-19)
                make.leading.equalTo(colorCategoryView.snp.trailing).offset(6)
            }
        } else {
            colorCategoryView.removeFromSuperview()
            label.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(5)
                make.leading.equalToSuperview().offset(14)
                make.bottom.equalToSuperview().offset(-19)
            }
        }
    }
}

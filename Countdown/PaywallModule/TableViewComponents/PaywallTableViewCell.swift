
import UIKit
import StoreKit

class PaywallTableViewCell: UITableViewCell {

    //MARK: - Naming
    
    static let identifier = "PaywallTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.medium.of(size: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.medium.of(size: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var priceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.regular.of(size: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = HelveticaNeueFont.bold.of(size: 20)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.borderWidth = 2
        layer.borderColor = UIColor.paywallCellBorder.cgColor
        backgroundColor = .paywallCellBackground
        layer.cornerRadius = 13
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceDescriptionLabel)
        contentView.addSubview(priceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(20))
            make.width.equalTo(161)
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(14))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(CGFloat.proportionalToDesignHeight(-18))
            make.leading.equalTo(titleLabel)
        }
        
        priceDescriptionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(CGFloat.proportionalToDesignWidth(-20))
            make.centerY.equalTo(titleLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(priceDescriptionLabel.snp.leading)
            make.centerY.equalTo(priceDescriptionLabel)
        }
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.displayName
        priceLabel.text = product.displayPrice
        
        if product.id == "countdown.year" {
            let priceString = product.displayPrice.replacingOccurrences(of: "[^0-9.,]", with: "", options: .regularExpression)
            let priceValue = Double(priceString.replacingOccurrences(of: ",", with: ".")) ?? 0
            let monthlyPrice = priceValue / 12
            let formatted = String(format: "%.2f", monthlyPrice)
            
            descriptionLabel.text = "Only \(formatted) ₽ per month"
        } else if product.id == "countdown.lifetime.once" {
            descriptionLabel.text = "Pay once, use forever"
        } else if product.id == "countdown.monthly" {
            descriptionLabel.text = "Perfect way to try"
        }
    }
}

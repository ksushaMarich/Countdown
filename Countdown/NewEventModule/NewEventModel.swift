
import UIKit

struct GradientsСolors {
    var colors: [UIColor]
}

class WidgetBackgroundCellView: UIView {
    private let gradientLayer = CAGradientLayer()

    init(colors: [UIColor]) {
        super.init(frame: .zero)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
    }

    
    init(image: UIImage) {
        super.init(frame: .zero)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
}


struct EventOptionsSize {
    let width: CGFloat
    let height: CGFloat
    
    static func getSize(for type: EventOptionsType) -> EventOptionsSize {
        switch type {
        case .repeatEvent:
            return EventOptionsSize(width: CGFloat.proportionalToDesignWidth(232), height: CGFloat.proportionalToDesignHeight(302))
        case .alert:
            return EventOptionsSize(width: CGFloat.proportionalToDesignWidth(241), height: CGFloat.proportionalToDesignHeight(402))
        case .category:
            return EventOptionsSize(width: CGFloat.proportionalToDesignWidth(303), height: CGFloat.proportionalToDesignHeight(350))
        }
    }
}

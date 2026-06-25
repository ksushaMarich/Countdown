
import UIKit
import SnapKit

class RoundedTableViewCell: UITableViewCell {

    //MARK: - Naming
    
    var cellPosition: CellPosition = .single
    
    private let normalBorderColor = UIColor.themeRed.withAlphaComponent(0.2).cgColor
    
    private let errorBorderColor = UIColor.themeRed.withAlphaComponent(0.8).cgColor
    
    private lazy var strokeColor = normalBorderColor
    
    //MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyRoundedCorners()
        selectionStyle = .none
    }
    
    //MARK: - Methods
    
    func configure(position: CellPosition? = nil) {
        if let position {
            cellPosition = position
        }
    }
    
    func setErrorStyle() {
        strokeColor = errorBorderColor
        applyRoundedCorners()
    }
    
    func setNormalStyle() {
        strokeColor = normalBorderColor
        applyRoundedCorners()
    }
    
    func applyRoundedCorners() {
        layoutIfNeeded()
        let cornerRadius: CGFloat = 8.0
        let bounds = contentView.bounds

        let path = UIBezierPath()

        switch cellPosition {
            
        case .single:
            path.move(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.minY))
            path.addArc(withCenter: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: CGFloat(-Double.pi/2),
                        endAngle: 0,
                        clockwise: true)
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - cornerRadius))
            path.addArc(withCenter: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi/2),
                        clockwise: true)
            path.addLine(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.maxY))
            path.addArc(withCenter: CGPoint(x: bounds.minX + cornerRadius, y: bounds.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: CGFloat(Double.pi/2),
                        endAngle: CGFloat(Double.pi),
                        clockwise: true)
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + cornerRadius))
            path.addArc(withCenter: CGPoint(x: bounds.minX + cornerRadius, y: bounds.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: CGFloat(Double.pi),
                        endAngle: CGFloat(3 * Double.pi / 2),
                        clockwise: true)
            path.close()

        case .top:
            path.move(to: CGPoint(x: bounds.minX + cornerRadius, y: bounds.minY))

            path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.minY))

            path.addArc(withCenter: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: -.pi / 2,
                        endAngle: 0,
                        clockwise: true)

            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))

            path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + cornerRadius))

            path.addArc(withCenter: CGPoint(x: bounds.minX + cornerRadius, y: bounds.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi,
                        endAngle: 3 * .pi / 2,
                        clockwise: true)

        case .middle:
            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))

            path.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))

        case .bottom:
            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))

            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY - cornerRadius))

            path.addArc(withCenter: CGPoint(x: bounds.minX + cornerRadius, y: bounds.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi,
                        endAngle: .pi / 2,
                        clockwise: false)

            path.addLine(to: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY))

            path.addArc(withCenter: CGPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .pi / 2,
                        endAngle: 0,
                        clockwise: false)

            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        }

        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = strokeColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = bounds

        if cellPosition == .top || cellPosition == .bottom || cellPosition == .single {
            let maskPath = UIBezierPath()
            switch cellPosition {
            case .single:
                maskPath.append(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius))
            case .top:
                maskPath.append(UIBezierPath(roundedRect: bounds,
                                            byRoundingCorners: [.topLeft, .topRight],
                                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)))
            case .bottom:
                maskPath.append(UIBezierPath(roundedRect: bounds,
                                            byRoundingCorners: [.bottomLeft, .bottomRight],
                                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)))
            default: break
            }
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            contentView.layer.mask = maskLayer
        } else {
            contentView.layer.mask = nil
        }
        
        contentView.layer.sublayers?.removeAll(where: { $0.name == "RoundedBorder" })
        borderLayer.name = "RoundedBorder"
        contentView.layer.addSublayer(borderLayer)
    }
}

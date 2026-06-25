import UIKit

class CircleLoaderView: UIView {
    private let circleLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCircle()
    }

    private func setupCircle() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = CGFloat(16)

        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 3 * CGFloat.pi / 2,
                                        clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0.75
        layer.addSublayer(circleLayer)

        animateRotation()
    }

    private func animateRotation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        circleLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

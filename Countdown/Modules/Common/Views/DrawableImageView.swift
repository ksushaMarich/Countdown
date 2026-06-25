import UIKit

class DrawableImageView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var dots: [CGPoint] = []
    var dotsCountChangeHandler: ((Int) -> Void)?
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addDot(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveImageWithDots() -> UIImage? {
        guard let imageWithDots = imageView.image else {
            print("No image available.")
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Could not get the context.")
            return nil
        }
        
        // Draw green background
            context.setFillColor(UIColor.init(hex: 0x20232A).cgColor)
            context.fill(CGRect(origin: .zero, size: imageView.frame.size))

            imageWithDots.draw(in: CGRect(origin: .zero, size: imageView.frame.size))

            context.setFillColor(UIColor.red.cgColor)
            context.setBlendMode(.normal)

            for dot in dots {
                context.fillEllipse(in: CGRect(x: dot.x - 5, y: dot.y - 5, width: 10, height: 10))
            }

            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

        return finalImage
    }
    
    
    @objc private func addDot(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: imageView)
        dots.append(tapPoint)
        addDotToImage(at: tapPoint)
        dotsCountChangeHandler?(dots.count)
    }
    
    private func addDotToImage(at point: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        imageView.image?.draw(in: imageView.bounds)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.orange.cgColor)
        context.fillEllipse(in: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = newImage
    }
}

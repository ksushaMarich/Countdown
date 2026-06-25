import UIKit

extension UIImage {
    var data: Data? {
        guard let data = self.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        return try? PropertyListEncoder().encode(data)
    }
}

extension Data {
    var image: UIImage? {
        guard let decoded = try? PropertyListDecoder().decode(Data.self, from: self) else {
            return nil
        }
        return UIImage(data: decoded)
    }
}

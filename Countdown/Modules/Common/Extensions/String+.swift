import UIKit

extension String {
    var isUrl: Bool {
        if let url = URL(string: self) {
            if UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        return false
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var isBackspace: Bool {
        if let char = self.cString(using: String.Encoding.utf8), strcmp(char, "\\b") == -92 {
            return true
        }

        return false
    }
    
    var cgFloat: CGFloat {
        return CGFloat(Int(self) ?? 0)
    }
}

import Foundation

extension Int {
    var toTime: String {
        let min = "\(self / 60)"
        var sec = "\(self % 60)"
        
        if sec.count == 1 {
            sec = "0\(sec)"
        }
        
        if min == "0" {
            return "00:\(sec)"
        }
        
        return "\(min):\(sec)"
    }
    
    var string: String {
        return "\(self)"
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    var secFromMin: Int {
        return self * 60
    }
}

extension String {
    var int: Int {
        return Int(self) ?? 0
    }
}

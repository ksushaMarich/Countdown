import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension Decimal {
    func double(toPlaces: Int = 2) -> Double {
        NSDecimalNumber(decimal: self).doubleValue.rounded(toPlaces: toPlaces)
    }
}

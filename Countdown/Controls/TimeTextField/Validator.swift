
import Foundation

struct Validity {

    let allows: Bool
    let shouldAddColon: Bool
    let shouldRemoveColon: Bool
    
    init(text: String) {
        let format = "SELF MATCHES %@"
        allows = NSPredicate(format: format, Pattern.getForAllows()).evaluate(with: text)
        shouldAddColon = NSPredicate(format: format, Pattern.getForColon()).evaluate(with: text)
        shouldRemoveColon = NSPredicate(format: format, Pattern.getRemoveColon()).evaluate(with: text)
    }
}

struct Pattern {
    
    static func getForAllows() -> String {
        #"^\d$|^(?:[0-1]\d|2[0-4])$|^\d : $|^\d : [0-5]$|^\d : [0-5]\d$|^(?:[0-1]\d|2[0-4]) : $|^(?:[0-1]\d|2[0-4]) : [0-5]$|^(?:[0-1]\d|2[0-4]) : [0-5]\d$"#
    }
    
    static func getForColon() -> String {
        return "^[3-9]$|^\\d{2}$"
    }
    
    static func getRemoveColon() -> String {
        return ".*:$"
    }
}

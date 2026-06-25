
import Foundation

final class DateFormatterService {
    
    static func makeStringForEventTableViewCell(for date: Date, time: EventTime?) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = (time?.hour != nil && time?.minute != nil) ? "MMMM d yyyy · HH:mm" : "MMMM d yyyy"
       return dateFormatter.string(from: date)
    }
}

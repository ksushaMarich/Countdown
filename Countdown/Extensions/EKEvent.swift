
import EventKit

extension EKEvent {
    
    func formattedStartDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM d yyyy"
        
        let dateString = dateFormatter.string(from: startDate)
        
        if isAllDay {
            return "\(dateString) · All day"
        } else {
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale.current
            timeFormatter.timeStyle = .short
            let timeString = timeFormatter.string(from: startDate)
            
            return "\(dateString) · \(timeString)"
        }
    }
}

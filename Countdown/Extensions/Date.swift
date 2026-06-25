import Foundation

extension Date {
    static func makeDateForEvent(_ event: Event) -> Date? {
        let dateOfEvent = event.date
        let calendar = Calendar.current
        let hours: Int
        let min: Int
        
        if let time = event.time {
            hours = time.hour
            min = time.minute
        } else {
            if calendar.isDateInToday(dateOfEvent) {
                hours = 23
                min = 59
            } else {
                hours = 0
                min = 0
            }
        }
        var components = calendar.dateComponents([.year, .month, .day], from: dateOfEvent)
        components.hour = hours
        components.minute = min
        
        return calendar.date(from: components)
    }
}

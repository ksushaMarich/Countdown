
import UIKit

struct DateComponentsBuilder: Equatable {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int?
    let minute: Int?

    func makeDate() -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        
        return Calendar.current.date(from: components)
    }
    
    static func makeString(for date: Date, time: EventTime?, isAllDay: Bool) -> String? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if isAllDay {
            dateFormatter.dateFormat = "MMMM d yyyy"
            return dateFormatter.string(from: date) + " · All day"
        } else if let time , let newDate = calendar.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: date) {
            dateFormatter.dateFormat = "MMMM d yyyy · HH:mm"
            return dateFormatter.string(from: newDate)
        } else {
            dateFormatter.dateFormat = "MMMM d yyyy"
            return dateFormatter.string(from: date)
        }
    }
}

typealias SortedEvents = [(month: String, events: [Event])]

enum EventSortOption: Int {
    case byDate
    case byCategory
}

struct EventTime: Equatable, Codable {
    var hour: Int
    var minute: Int
    
    func encodeTime() throws -> Data {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return try encoder.encode(self)
    }
    
    static func decodeTime(_ data: Data) throws -> EventTime? {
        try PropertyListDecoder().decode(EventTime.self, from: data)
    }
}

enum EventCreationError: Error {
    case missingRequiredData
}

enum CellPosition {
    case top
    case middle
    case bottom
    case single
}

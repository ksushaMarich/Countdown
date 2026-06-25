import UIKit

struct EventTimeLeft {
    let days: Int
    let hours: String
    let minutes: String
}

struct WidgetBackgroundState: Codable, Equatable {
    let colorIndex: Int
    let imageIndex: Int
    
   static func encode(_ state: WidgetBackgroundState) -> Data? {
       let encoder = JSONEncoder()
       do {
           return try encoder.encode(state)
       } catch {
           print("Encoding error: \(error)")
           return nil
       }
   }
   
   static func decode(_ data: Data) -> WidgetBackgroundState? {
       let decoder = JSONDecoder()
       do {
           return try decoder.decode(WidgetBackgroundState.self, from: data)
       } catch {
           print("Decoding error: \(error)")
           return nil
       }
   }
}

struct Event: Equatable {
    
    var name: String
    var date: Date
    var note: String
    var time: EventTime?
    var isAllDay: Bool
    var repeatOption: String
    var alertOption: String
    var category: String
    var widgetBackgroundState: WidgetBackgroundState
    var calendarItemIdentifier: String?
    var id: UUID?
    var isPrivate: Bool {
       category != "Private event"
    }
    
    var daysLeft: Int? {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date)).day
    }
    
    init(name: String, date: Date, note: String, time: EventTime? = nil, category: String, repeatOption: String, alertOption: String, widgetBackgroundState: WidgetBackgroundState, isAllDay: Bool = false, calendarItemIdentifier: String? = nil, id: UUID?) {
        self.name = name
        self.date = date
        self.note = note
        self.time = time
        self.category = category
        self.isAllDay = isAllDay
        self.calendarItemIdentifier = calendarItemIdentifier
        self.repeatOption = repeatOption
        self.alertOption = alertOption
        self.widgetBackgroundState = widgetBackgroundState
        self.id = id
    }
    
    static func makeEventFromCoreData(_ eventCoreData: EventCoreData) throws -> Event {
        guard let name = eventCoreData.name, let date = eventCoreData.date, let category = eventCoreData.category, let repeatOption = eventCoreData.repeatOption, let alertOption = eventCoreData.alertOption, let widgetBackgroundStateData = eventCoreData.widgetBackgroundState, let widgetBackgroundState = WidgetBackgroundState.decode(widgetBackgroundStateData), let note = eventCoreData.note else {
            throw EventCreationError.missingRequiredData
        }
        let eventTime: EventTime?
        if let time = eventCoreData.time {
            eventTime = try EventTime.decodeTime(time)
        } else {
            eventTime = nil
        }
        
        return Event(name: name, date: date, note: note, time: eventTime, category: category, repeatOption: repeatOption, alertOption: alertOption, widgetBackgroundState: widgetBackgroundState, isAllDay: eventCoreData.isAllDay, calendarItemIdentifier: eventCoreData.calendarItemIdentifier, id: eventCoreData.id)
    }
    
    func getTimeLeft() -> EventTimeLeft? {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let now = Date()
        
        var eventDateTime = calendar.startOfDay(for: date)
        if let time = time {
            eventDateTime = calendar.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: eventDateTime) ?? eventDateTime
        } else {
            eventDateTime = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: eventDateTime) ?? eventDateTime
        }
        
        guard eventDateTime > now else {
            return EventTimeLeft(days: 0, hours: "00", minutes: "00")
        }
        
        let totalMinutes = calendar.dateComponents([.minute], from: now, to: eventDateTime).minute ?? 0
        let days = totalMinutes / (60 * 24)
        let hoursInt = (totalMinutes % (60 * 24)) / 60
        let minutesInt = totalMinutes % 60
        
        let hours = String(format: "%02d", hoursInt)
        let minutes = String(format: "%02d", minutesInt)
        
        return EventTimeLeft(days: days, hours: hours, minutes: minutes)
    }
}

enum RepeatOption: String {
    case never = "Never"
    case everyDay = "Every day"
    case everyWeek = "Every week"
    case everyTwoWeeks = "Every 2 weeks"
    case everyMonth = "Every month"
    case everyYear = "Every year"
    
    static func getOptions() -> [String] {
        [RepeatOption.never.rawValue, RepeatOption.everyDay.rawValue, RepeatOption.everyWeek.rawValue, RepeatOption.everyTwoWeeks.rawValue, RepeatOption.everyMonth.rawValue, RepeatOption.everyYear.rawValue]
    }
}

enum EventOptionsType {
    case repeatEvent, alert, category

    func getOptions() -> [String] {
        switch self {
            
        case .repeatEvent:
            return RepeatOption.getOptions()
        case .alert:
            return ["At time of event", "5 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before"]
        case .category:
            let savedOptions = CustomCategoryStorage.shared.loadCategories().map({$0.name})
            
            return [ "Birthday", "Private event", "Family meeting",
            "Holiday", "Party", "Work meeting"] + savedOptions
        }
    }
    
    func getColors() -> [UIColor]? {
        guard self == .category else { return nil }
        let savedColors = CustomCategoryStorage.shared.loadCategories().map({CustomCategoryColorType.giveColors()[$0.colorIndex]})
        return [.greenCategory, .redCategory, .blueCategory, .mustardCategory, .lilacCategory, .mintCategory] + savedColors
    }
}

struct WidgetTheme {
    static let images: [UIImage?] = [nil, .leafTexture, .partyTexture, .concertTexture, .birthdayTexture, .workTexture, .familyTexture]
    static let colors: [[UIColor]] = [[.themeRed, .darkRedWidget], [.brightYellowWidget, .darkYelloWidget], [.brightLightGreenWidget, .darkLightGreenWidget], [.brightGreenWidget, .darkGreenWidget], [.brightLightBlueWidget, .darkLightBlueWidget], [.brightBlueWidget, .darkBlueWidget], [.widgetPurple, .darkPurpleWidget]]
}

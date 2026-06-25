import WidgetKit
import AppIntents
import SwiftUI
import CoreData
import CoreLocation
import UIKit

struct Provider: AppIntentTimelineProvider {
    
    typealias Entry = SimpleEntry
    typealias Intent = SelectEventIntent

    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), event: EventEntity(id: UUID(), name: "Your event", dateOfEvent: Date(), image: 0, colors: 0, isPrivate: false))
    }

    func snapshot(for configuration: SelectEventIntent, in context: Context) async -> SimpleEntry {
        makeEntry(for: configuration)
    }
    
    func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var eventEntry = makeEntry(for: configuration)
        let calendar = Calendar.current
        var event = eventEntry.event

        if event.dateOfEvent < Date(), let repeatOption = RepeatOptionsStore.shared.get(by: event.id.uuidString) {
            
            switch repeatOption.repeatOption {
            case RepeatOption.everyDay.rawValue:
                let dateOfEvent = calendar.date(byAdding: .day, value: 1, to: event.dateOfEvent) ?? event.dateOfEvent
                event.dateOfEvent = dateOfEvent
                AppGroupEventService.shared.updateEvent(id: event.id.uuidString, name: event.name, dateOfEvent: dateOfEvent, image: event.image, colors: event.colors, isPrivate: event.isPrivate)
                
            case RepeatOption.everyWeek.rawValue:
                let dateOfEvent = calendar.date(byAdding: .day, value: 7, to: event.dateOfEvent) ?? event.dateOfEvent
                event.dateOfEvent = dateOfEvent
                AppGroupEventService.shared.updateEvent(id: event.id.uuidString, name: event.name, dateOfEvent: dateOfEvent, image: event.image, colors: event.colors, isPrivate: event.isPrivate)
                eventEntry = SimpleEntry(date: Date(), event: event)
                
            case RepeatOption.everyTwoWeeks.rawValue:
                let dateOfEvent = calendar.date(byAdding: .day, value: 14, to: event.dateOfEvent) ?? event.dateOfEvent
                event.dateOfEvent = dateOfEvent
                AppGroupEventService.shared.updateEvent(id: event.id.uuidString, name: event.name, dateOfEvent: dateOfEvent, image: event.image, colors: event.colors, isPrivate: event.isPrivate)
                eventEntry = SimpleEntry(date: Date(), event: event)
                
            case RepeatOption.everyMonth.rawValue:
                if Date.hasSameDayInNextMonth(for: event.dateOfEvent) {
                    let dateOfEvent = calendar.date(byAdding: .month, value: 1, to: event.dateOfEvent) ?? event.dateOfEvent
                    event.dateOfEvent = dateOfEvent
                    AppGroupEventService.shared.updateEvent(id: event.id.uuidString, name: event.name, dateOfEvent: dateOfEvent, image: event.image, colors: event.colors, isPrivate: event.isPrivate)
                    eventEntry = SimpleEntry(date: Date(), event: event)
                } else {
                    eventEntry = SimpleEntry(date: Date(), event: EventEntity(id: UUID(), name: "Past event", dateOfEvent: event.dateOfEvent, image: 0, colors: 0, isPrivate: event.isPrivate))
                }
                
            case RepeatOption.everyYear.rawValue:
                let dateOfEvent = calendar.date(byAdding: .year, value: 1, to: event.dateOfEvent) ?? event.dateOfEvent
                event.dateOfEvent = dateOfEvent
                AppGroupEventService.shared.updateEvent(id: event.id.uuidString, name: event.name, dateOfEvent: dateOfEvent, image: event.image, colors: event.colors, isPrivate: event.isPrivate)
                eventEntry = SimpleEntry(date: Date(), event: event)
                
            default:
                eventEntry = SimpleEntry(date: Date(), event: EventEntity(id: UUID(), name: "Past event", dateOfEvent: event.dateOfEvent, image: 0, colors: 0, isPrivate: event.isPrivate))
            }
        }
        
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, event: eventEntry.event)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .after(Date().addingTimeInterval(60)))
    }

    private func makeEntry(for configuration: SelectEventIntent) -> SimpleEntry {
        let events = AppGroupEventService.shared.getAllEvents()
        
        guard let event = events.first(where: { $0.id == configuration.eventId?.id.uuidString}) ?? events.first else {
            return SimpleEntry(date: Date(), event: EventEntity(id: UUID(), name: "Your event", dateOfEvent: Date(), image: 0, colors: 0, isPrivate: false))
        }

        return SimpleEntry(date: Date(), event: EventEntity(id: UUID(uuidString: event.id) ?? UUID(), name: event.name, dateOfEvent: event.dateOfEvent, image: event.image, colors: event.colors, isPrivate: event.isPrivate))
    }
}



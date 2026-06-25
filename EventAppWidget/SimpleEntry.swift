import Foundation
import AppIntents
import WidgetKit
import SwiftUI

struct EventEntity: Codable, AppEntity, Identifiable{
    typealias DefaultQuery = EventQuery
    
    let id: UUID
    let name: String
    var dateOfEvent: Date
    let image: Int
    let colors: Int
    let isPrivate: Bool
    
    var displayRepresentation: DisplayRepresentation {
            DisplayRepresentation(title: "\(name)")
        }

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Event"

    static var defaultQuery =  EventQuery()
}

struct  EventQuery: EntityQuery {
    
    func suggestedEntities() async throws -> [EventEntity] {
        let events = AppGroupEventService.shared.getAllEvents().filter({ !$0.isPrivate || PrivateEventsVisibilityManager.shared.isPrivateEventsVisible})
        return events.map { EventEntity( id: UUID(uuidString: $0.id)!, name: $0.name, dateOfEvent: $0.dateOfEvent, image: $0.image, colors: $0.colors, isPrivate: $0.isPrivate) }
    }
    
    func entities(for identifiers: [UUID]) async throws -> [EventEntity] {
        let allEvents = AppGroupEventService.shared.getAllEvents()
           .map { EventEntity( id: UUID(uuidString: $0.id)!, name: $0.name, dateOfEvent: $0.dateOfEvent, image: $0.image, colors: $0.colors, isPrivate: $0.isPrivate) }
        
        return allEvents.filter { identifiers.contains($0.id) }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let event: EventEntity
}

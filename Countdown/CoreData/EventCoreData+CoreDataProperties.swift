
public import Foundation
public import CoreData


public typealias EventCoreDataCoreDataPropertiesSet = NSSet

extension EventCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventCoreData> {
        return NSFetchRequest<EventCoreData>(entityName: "EventCoreData")
    }

    @NSManaged public var alertOption: String?
    @NSManaged public var calendarItemIdentifier: String?
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isAllDay: Bool
    @NSManaged public var name: String?
    @NSManaged public var repeatOption: String?
    @NSManaged public var time: Data?
    @NSManaged public var widgetBackgroundState: Data?
    @NSManaged public var note: String?

}

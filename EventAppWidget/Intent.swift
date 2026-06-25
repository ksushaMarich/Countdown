import AppIntents
import UIKit

struct SelectEventIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Event selection"
    
    @Parameter(title: "Event")
    var eventId: EventEntity?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Показать \(\.$eventId)")
    }
}



struct EventLaunchIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Event"
    
    @Parameter(title: "Event ID")
    var id: String
    
    init() { }
    
    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

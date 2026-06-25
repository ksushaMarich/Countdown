
import WidgetKit
import SwiftUI

@main
struct EventAppWidget: Widget {
    let kind: String = "EventAppWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectEventIntent.self, provider: Provider()) { entry in
            
            EventAppWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(uiColor: WidgetTheme.colors[entry.event.colors][0]),
                                Color(uiColor: WidgetTheme.colors[entry.event.colors][1])
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        if let uiImage = WidgetTheme.images[entry.event.image] {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .opacity(0.1)
                                .clipped()
                        }
                    }
                }
                .widgetURL((URL(string: "myapp://event?id=\(entry.event.id.uuidString)")))
        }
        .configurationDisplayName("Event Widget")
        .description("Displays countdown for selected event")
        .supportedFamilies([.systemSmall, .systemMedium])
        .promptsForUserConfiguration()
    }
}


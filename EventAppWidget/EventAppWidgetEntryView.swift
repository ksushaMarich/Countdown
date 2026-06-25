import SwiftUI

struct EventAppWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidget(
                name: entry.event.name,
                date: entry.event.dateOfEvent
            )
        default:
            CountdownWidget(
                name: entry.event.name,
                date: entry.event.dateOfEvent
            )
        }
    }
}

// MARK: - Small

private struct SmallWidget: View {
    let name: String
    let date: Date
    
    var body: some View {
        GeometryReader { geo in
            let rem = timeRemaining(until: date)
            let h = geo.size.height
            let w = geo.size.width
            let big = min(geo.size.height, geo.size.width)
            let unitSize    = min(h, w) * 0.12
            let colonSize   = min(h, w) * 0.30
            let titleSize   = big * 0.13
            let numberSize  = big * 0.56
            let captionSize = big * 0.13
            let dateSize    = big * 0.12
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(InterFont.bold.of(size: titleSize))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .allowsTightening(true)
                if rem.days != 0 {
                    Text("\(rem.days)")
                        .font(InterFont.bold.of(size: numberSize))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, big * 0.03)
                    
                    Text("days left")
                        .font(InterFont.regular.of(size: captionSize))
                        .foregroundColor(.white.opacity(0.95))
                        .padding(.top, big * 0.05)
                } else {
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        // Hours
                        VStack(spacing: 0) {
                            Text(String(format: "%02d", rem.hours))
                                .font(InterFont.bold.of(size: numberSize * 0.82))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.top, h * 0.02)
                            
                            Text("hours")
                                .font(InterFont.regular.of(size: unitSize))
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.top, h * 0.01)
                        }
                        
                        // Colon
                        Text(":")
                            .font(HelveticaNeueFont.bold.of(size: colonSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                            .padding(.horizontal, w * 0.01)
                            .padding(.top, h * 0.01)
                        
                        // Minutes
                        VStack(spacing: 0) {
                            Text(String(format: "%02d", rem.minutes))
                                .font(InterFont.bold.of(size: numberSize * 0.82))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.top, h * 0.02)
                            
                            Text("min")
                                .font(InterFont.regular.of(size: unitSize))
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.top, h * 0.01)
                        }
                        
                    }
                    
                }
                
                Text(dateString(date))
                    .font(InterFont.medium.of(size: dateSize))
                    .foregroundColor(.white.opacity(0.95))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.top, big * 0.04)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical, big * 0.12)
            .padding(.horizontal, big * 0.10)
            
        }
    }
}

// MARK: - Medium / Large

private struct CountdownWidget: View {
    let name: String
    let date: Date
    
    var body: some View {
        GeometryReader { geo in
            let rem = timeRemaining(until: date)
            let h = geo.size.height
            let w = geo.size.width
            
            // Adaptive sizes
            let titleSize   = min(h, w) * 0.13
            let subtitle    = min(h, w) * 0.11
            let numberSize  = min(h, w) * 0.40
            let unitSize    = min(h, w) * 0.12
            let colonSize   = min(h, w) * 0.30
            
            VStack(alignment: .leading, spacing: 0) {
                // Title
                Text(name)
                    .font(InterFont.bold.of(size: titleSize))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .allowsTightening(true)
                    .padding(.top, h * 0.05)
                
                // Date
                Text(dateString(date))
                    .font(InterFont.medium.of(size: subtitle))
                    .foregroundColor(.white.opacity(0.95))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.top, h * 0.01)
                
                // Countdown
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    if rem.days != 0 {
                        Spacer()
                        VStack(spacing: 0) {
                            Text("\(rem.days)")
                                .font(InterFont.bold.of(size: numberSize * 0.82))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .padding(.top, h * 0.02)
                            
                            Text("days left")
                                .font(InterFont.regular.of(size: unitSize))
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.top, h * 0.01)
                        }
                        Spacer()
                    } else {
                        Spacer()
                        
                        // Hours
                        VStack(spacing: 0) {
                            Text(String(format: "%02d", rem.hours))
                                .font(InterFont.bold.of(size: numberSize * 0.82))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .padding(.top, h * 0.02)
                            
                            Text("hours")
                                .font(InterFont.regular.of(size: unitSize))
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.top, h * 0.01)
                        }
                        
                        // Colon
                        Text(":")
                            .font(HelveticaNeueFont.bold.of(size: colonSize))
                            .foregroundColor(.white)
                            .padding(.horizontal, w * 0.01)
                            .padding(.top, h * 0.01)
                        
                        // Minutes
                        VStack(spacing: 0) {
                            Text(String(format: "%02d", rem.minutes))
                                .font(InterFont.bold.of(size: numberSize * 0.82))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .padding(.top, h * 0.02)
                            
                            Text("min")
                                .font(InterFont.regular.of(size: unitSize))
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.top, h * 0.01)
                        }
                        Spacer()
                    }
                }
                .padding(.top, h * 0.04)
                
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, w * 0.06)
            .padding(.bottom, h * 0.06)
        }
    }
}

// MARK: - Helpers

private func dateString(_ date: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.dateFormat = "MMMM d, yyyy"
    return df.string(from: date)
}

private func timeRemaining(until eventDate: Date) -> (days: Int, hours: Int, minutes: Int) {
    let now = Date()
    if now >= eventDate {
        return (0, 0, 0)
    }
    
    let calendar = Calendar.current
    let comps = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: eventDate)
    let days = max(0, comps.day ?? 0)
    let hours = max(0, comps.hour ?? 0)
    let minutes = max(0, comps.minute ?? 0)
    // Make sure hours/minutes are remainders (0...23 / 0...59)
    // If .day is present, .hour and .minute are already remainders for the delta.
    return (days, hours, minutes)
}

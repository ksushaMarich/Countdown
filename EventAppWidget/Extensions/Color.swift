
import SwiftUI

extension Color {
    init?(data: Data) {
        guard let components = try? JSONDecoder().decode([CGFloat].self, from: data),
              components.count == 4 else { return nil }
        self = Color(red: Double(components[0]),
                     green: Double(components[1]),
                     blue: Double(components[2]),
                     opacity: Double(components[3]))
    }
}

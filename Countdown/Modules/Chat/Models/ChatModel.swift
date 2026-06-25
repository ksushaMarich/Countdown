import Foundation

enum MessageType {
    case writing
    case message(MessageModelViewModel)
}

struct MessageModelViewModel: Codable, Equatable, Hashable {
    let text: String
    let isUserMessage: Bool
    let date: Date
}


extension String {
    var asEventTime: EventTime? {

        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let components = trimmed.components(separatedBy: " : ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]),
              (0..<24).contains(hour),
              (0..<60).contains(minute)
        else { return nil }
        return EventTime(hour: hour, minute: minute)
    }
}

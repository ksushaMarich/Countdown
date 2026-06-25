import Foundation

extension Date {
    static func hasSameDayInNextMonth(for date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: date) else {
            return false
        }
        
        let components = calendar.dateComponents([.year, .month], from: nextMonthDate)
        guard let _ = components.year,
              let _ = components.month,
              let range = calendar.range(of: .day, in: .month, for: nextMonthDate) else {
            return false
        }
        
        let daysInNextMonth = Array(range)
        
        return daysInNextMonth.contains(day)
    }
}

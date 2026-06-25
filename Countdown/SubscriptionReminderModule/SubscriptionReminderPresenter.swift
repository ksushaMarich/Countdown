import Foundation
import UIKit

protocol SubscriptionReminderViewInput: AnyObject {
    var presenter: SubscriptionReminderViewOutput? { get set }
    func configureViewWithEvent(_ event: Event)
}

protocol SubscriptionReminderViewOutput: AnyObject {
    var view: SubscriptionReminderViewInput? { get set }
    func addwidgetButtonTapped()
    func viewDidLoad()
    func addwidget()
}

final class SubscriptionReminderPresenter {
    weak var view: SubscriptionReminderViewInput?
    var router: SubscriptionReminderRouterProtocol?
    
    private let calendar = Calendar.current
    private let now = Date()
    
    private func closestEvent(from events: [Event]) -> Event? {
        guard !events.isEmpty else { return nil }

        let minDays = events.compactMap { $0.daysLeft }.min()!
        let sameDayEvents = events.filter { $0.daysLeft == minDays }
        
        let minHours = sameDayEvents.map { hoursLeft(for: $0) }.min()!
        let sameHourEvents = sameDayEvents.filter { hoursLeft(for: $0) == minHours }
        
        let minMinutes = sameHourEvents.map { minutesLeft(for: $0) }.min()!
        let finalEvents = sameHourEvents.filter { minutesLeft(for: $0) == minMinutes }
        
        return finalEvents.first
    }

    private func hoursLeft(for event: Event) -> Int {
        let startOfDay = calendar.startOfDay(for: event.date)
        let startDateTime: Date
        if let t = event.time {
            startDateTime = calendar.date(
                bySettingHour: t.hour,
                minute: t.minute,
                second: 0,
                of: event.date
            ) ?? startOfDay
        } else {
            startDateTime = startOfDay
        }
        return Int(startDateTime.timeIntervalSince(now) / 3600)
    }

    private func minutesLeft(for event: Event) -> Int {
        let startOfDay = calendar.startOfDay(for: event.date)
        let startDateTime: Date
        if let t = event.time {
            startDateTime = calendar.date(
                bySettingHour: t.hour,
                minute: t.minute,
                second: 0,
                of: event.date
            ) ?? startOfDay
        } else {
            startDateTime = startOfDay
        }
        return Int(startDateTime.timeIntervalSince(now) / 60)
    }
}

extension SubscriptionReminderPresenter: SubscriptionReminderViewOutput {
    
    func viewDidLoad() {
        CoreDataManager.shared.fetchEvents { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let events):
                guard let closestEvent = closestEvent(from: events) else { return }
                view?.configureViewWithEvent(closestEvent)
            case .failure(_):
                guard let viewController = view as? UIViewController else { return }
                viewController.showAlert(title: "Service Temporarily Unavailable", message: "Please try again later") {}
            }
        }
    }
    
    func addwidgetButtonTapped() {
        router?.dismissAndShowPaywall()
    }
    
    func addwidget() {
        print("Add widget")
    }
}


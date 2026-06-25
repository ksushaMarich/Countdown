
import UIKit

protocol UserEventViewInput: AnyObject {
    func setGetProButton()
    func updateNumberOfUserEvents(with number: Int)
    func showSuccessRestoreAlert()
}

protocol UserEventViewOutput: AnyObject {
    var eventsCount: Int? { get }
    func viewDidLoad()
    func viewWillAppear()
    func presentPaywall()
    func presentDocuments(wiht linkType: LinkType)
    func restorePurchases() async throws
    func openMail()
    func getIsPrivateEventsVisible() -> Bool
    func getIsNotificationsVisible() -> Bool
    func updateIsPrivateEventsVisible(with value: Bool)
    func updateIsNotificationsVisible(with value: Bool)
}

class UserPresenter {
    weak var view: UserEventViewInput?
    var router: UserModuleRouterProtocol?
    
    init() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleRestoreSuccess),
                name: NSNotification.Name("IAPRestoreSuccessful"),
                object: nil
            )
    }
    
    private(set) var eventsCount: Int?
    private var isPrivateEventsVisible: Bool {
        PrivateEventsVisibilityManager.shared.isPrivateEventsVisible
    }
    
    private var isNotificationsVisible: Bool {
        NotificationsVisibilityStorage.shared.isNotificationsVisible
    }
    
    @objc func handleRestoreSuccess() {
        DispatchQueue.main.async {
            self.view?.showSuccessRestoreAlert()
        }
    }
}

extension UserPresenter: UserEventViewOutput {
    
    func presentPaywall() {
        router?.presentPaywall()
    }
    
    func viewDidLoad() {
        if !SubscriptionsService.shared.hasSubscription {
            view?.setGetProButton()
        }
    }
    
    func viewWillAppear() {
        CoreDataManager.shared.fetchEvents { result in
            switch result {
            case .success(let events):
                self.eventsCount = events.count
                self.view?.updateNumberOfUserEvents(with: events.count)
            case .failure(_):
                self.eventsCount = 0
            }
        }
    }
    
    func presentDocuments(wiht linkType: LinkType) {
        router?.presentWebViewController(with: linkType)
    }
    
    func restorePurchases() async throws {
        do {
            try await SubscriptionsService.shared.restorePurchases()
        } catch {
            throw error
        }
    }
    
    func openMail() {
        if let url = URL(string: "mailto:appstoreconnect37@gmail.com") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func getIsPrivateEventsVisible() -> Bool {
        isPrivateEventsVisible
    }
    
    func getIsNotificationsVisible() -> Bool {
        isNotificationsVisible
    }
    
    func updateIsPrivateEventsVisible(with value: Bool) {
        
        PrivateEventsVisibilityManager.shared.setVisibilityValue(with: value)
        
        CoreDataManager.shared.fetchEvents { result in
            switch result {
            case .success(let events):
                let privateEvents = events.filter { $0.category == "Private event" }
                let notificationService = NotificationService.shared
                
                if value {
                    for event in privateEvents {
                        guard let id = event.id?.uuidString, let date =  Date.makeDateForEvent(event) else { return }
                        notificationService.scheduleNotification(id: id, body: event.name, date: date, isPrivate: true, alertOption: event.alertOption)
                    }
                } else {
                    for event in privateEvents {
                        guard let id = event.id?.uuidString else { return }
                        notificationService.removeNotification(with: id)
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    func updateIsNotificationsVisible(with value: Bool) {
        NotificationsVisibilityStorage.shared.setVisibilityValue(with: value)
        
        if !value {
            NotificationService.shared.removeAllNotifications()
            return
        }
        
        CoreDataManager.shared.fetchEvents { result in
            switch result {
            case .success(let events):
                for event in events {
                    guard let date =  Date.makeDateForEvent(event), let id = event.id?.uuidString else { return }
                    NotificationService.shared.scheduleNotification(id: id, body: event.name, date: date, isPrivate: event.isPrivate, alertOption: event.alertOption)
                }
            case .failure(_):
                return
            }
        }
    }
}

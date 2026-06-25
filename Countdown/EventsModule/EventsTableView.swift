
import UIKit

class EventsTableView: UITableView {

    //MARK: - Naming
    
    private var events: SortedEvents
    
    //MARK: - Life cycle
    
    init(events: SortedEvents) {
        self.events = events
        super.init(frame: .zero, style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

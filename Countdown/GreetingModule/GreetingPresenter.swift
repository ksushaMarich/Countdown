import Foundation

protocol GreetingViewInput: AnyObject {
    var presenter: GreetingViewOutput? { get set }
}

protocol GreetingViewOutput: AnyObject {
    var view: GreetingViewInput? { get set }
    func newEventButtonTapped()
    func importEventButtonTapped()
}

final class GreetingPresenter {
    
    weak var view: GreetingViewInput?
    var router: GreetingModuleRouterProtocol?
}

extension GreetingPresenter: GreetingViewOutput {
    
    func newEventButtonTapped() {
        router?.navigateToNewEventModule()
    }
    
    func importEventButtonTapped() {
        router?.navigateToImportEventModule()
    }
}


import Dispatch

protocol SplashViewInput: AnyObject {
    var presenter: SplashViewOutput? { get set }
    func animateCircles()
}

protocol SplashViewOutput: AnyObject {
    var view: SplashViewInput? { get set }
    func viewDidLoad()
    func animationСompleted()
}

final class SplashPresenter {
    
    //MARK: - Naming
    
    weak var view: SplashViewInput?
    
    private let id: String?
    
    //MARK: - Life cycle
    
    init (id: String?) {
        self.id = id
    }
    
    //MARK: - Methods
    
    private func continueToMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SplashModuleRouter.showStartScreen(id: self.id)
        }
    }
}

extension SplashPresenter: SplashViewOutput {
    
    func viewDidLoad() {
        NotificationService.shared.checkAuthorizationStatus { _ in
            DispatchQueue.main.async {
                self.view?.animateCircles()
            }
        }
    }
    
    func animationСompleted() {
        continueToMain()
    }
}

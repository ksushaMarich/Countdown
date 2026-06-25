
import UIKit

protocol CustomCategoryViewInput: AnyObject {
    var presenter: CustomCategoryViewOutput? { get set }
    func giveCategoryName() -> String?
}

protocol CustomCategoryViewOutput: AnyObject {
    var view: CustomCategoryViewInput? { get set }
    var colors: [UIColor] { get }
    var indexOfSelectedColor: Int { get }
    func getVisibleContentHeight() -> CGFloat
    func updateIndexOfSelectedColor(_ index: Int)
    func saveNewCategory()
}

final class CustomCategoryPresenter {
    
    var completion: ((CustomCategoryModel) -> Void)
    
    weak var view: CustomCategoryViewInput?
    var router: CustomCategoryModuleRouterProtocol?
    
    private(set) var colors = CustomCategoryColorType.giveColors()
    
    private(set) var indexOfSelectedColor = 0
    
    init(completion: @escaping ((CustomCategoryModel) -> Void)) {
        self.completion = completion
    }
}

extension CustomCategoryPresenter: CustomCategoryViewOutput {
    
    func getVisibleContentHeight() -> CGFloat {
        guard let viewController = view as? UIViewController, let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let statusBarManager = windowScene.statusBarManager else { return 0 }
        
        let statusBarHeight = statusBarManager.statusBarFrame.height
        let screenHeight = UIScreen.main.bounds.height
        let navBarHeight = (viewController.navigationController?.navigationBar.frame.height ?? 0)
        return screenHeight - navBarHeight - statusBarHeight
    }
    
    func updateIndexOfSelectedColor(_ index: Int) {
        indexOfSelectedColor = index
    }
    
    func saveNewCategory() {
        guard let name = view?.giveCategoryName() else { return }
        let category = CustomCategoryModel(name: name == "" ? "New category" : name, colorIndex: indexOfSelectedColor)
        CustomCategoryStorage.shared.addCategory(category)
        completion(category)
    }
}

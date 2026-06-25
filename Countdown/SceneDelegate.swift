
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var lastHandledURL: URL?

   func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
       guard
           let url = URLContexts.first?.url,
           url.scheme == "myapp",
           let id = url.queryParameters?["id"]
       else { return }
       
       window?.rootViewController = SplashModuleBuilder.build(id: id)
   }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .light
        
        var id: String? = nil
        
        if let url = connectionOptions.urlContexts.first?.url, url.scheme == "myapp", let stringId = url.queryParameters?["id"] {
            id = stringId
        }
            
        window?.rootViewController = SplashModuleBuilder.build(id: id)
        window?.makeKeyAndVisible()

        Task {
            try await SubscriptionsService.shared.fetchProducts()
            try await SubscriptionsService.shared.hasActiveSubscription()
        }
    }
}


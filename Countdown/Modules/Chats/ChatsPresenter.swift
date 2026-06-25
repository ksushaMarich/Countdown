import Foundation

class ChatsPresenter {
    var chats: [ChatViewModel] = [] {
        didSet {
            view?.update()
        }
    }
    
    private weak var view: ChatsViewInput?
    private let networkService = ChatNetworkService()
    private let favoriteService = FavoriteService<ChatModel>(key: .chats)
    
    init(view: ChatsViewInput) {
        self.view = view
    }
    
    func viewDidLoad() {
        //favoriteService.favorites.append(.init(listModel: .init(id: "1", images: [""], name: "Test", age: "123", description: "Descp", prompt: "ЗЛОЙ СТОРОЖ"), messages: []))
    }
    
    func viewWillAppear() {
        reloadItems()
    }
    
    func getChatModel(for indexPath: IndexPath) -> ListModel {
        favoriteService.favorites[indexPath.row].listModel
    }
    
    func deleteChat(for indexPath: IndexPath) {
        let deletionItem = favoriteService.favorites[indexPath.row]
        favoriteService.remove(deletionItem)
        reloadItems()
    }
    
    private func reloadItems() {
        chats = favoriteService.favorites.map { chat in
                .init(
                    avatarUrl: URL(string: chat.listModel.images.first ?? ""),
                    name: chat.listModel.name,
                    lastMessage: chat.messages.last?.text ?? "...",
                    date: chat.messages.last?.date.getBeautifulDate() ?? ""
                )
        }
    }
}

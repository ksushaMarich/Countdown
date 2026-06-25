import Foundation

struct ListModel: Codable, Equatable {
    let id: String
    let images: [String]
    let name: String
    let age: String
    let description: String
    let prompt: String
}

struct ChatModel: Codable, Equatable {
    let listModel: ListModel
    var messages: [MessageModelViewModel]
}

class ChatPresenter {
    var showWriting: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.view?.update()
            }
        }
    }
    
    var messages: [MessageModelViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.update()
            }
            
            if let index = favoriteService.favorites.firstIndex(where: { $0.listModel.id == listModel.id }) {
                favoriteService.favorites[index].messages = messages
            }
        }
    }
    
    private let listModel: ListModel
    private let networkService = ChatNetworkService()
    private let favoriteService = FavoriteService<ChatModel>(key: .chats)
    
    weak var view: ChatViewInput?
    
    init(listModel: ListModel) {
        self.listModel = listModel
        
        if let chatModel = favoriteService.favorites.first(where: { $0.listModel.id == listModel.id }) {
            messages = chatModel.messages
        } else {
            favoriteService.favorites.append(.init(listModel: listModel, messages: []))
        }
    }
    
    func viewDidLoad() {
//        if messages.isEmpty, abTestManager.needSendFirstMessage {
//            sendMessageToServer(text: "Hello")
//        }
        view?.setupProfileImage(link: listModel.images.first ?? "")
    }
    
    func viewDidAppear() {
        if messages.isEmpty {
            view?.showKeyboard()
        }
    }
    
    func sendMessage(text: String) {
        Task {
            self.showWriting = true
            self.sendMessageToServer(text: text)
            
            self.messages.append(
                .init(text: text, isUserMessage: true, date: Date())
            )
        }
    }
    
    private func sendMessageToServer(text: String) {
        networkService.send(
            message: .init(role: .user, content: text),
            history: messages.map { .init(role: $0.isUserMessage ? .user : .system, content: $0.text) },
            prompt: listModel.prompt
        ) { [weak self] result in
            switch result {
            case .success(let messageModel):
                guard let message = messageModel.choices.last else {
                    self?.view?.showError(text: "Ошибка 123") // TODO придумать текст
                    return
                }
                self?.messages.append(
                    .init(text: message.message.content, isUserMessage: false, date: Date())
                )
                
                UserDefaults.outgoingTokenLimit += text.count
                UserDefaults.incomingTokenLimit += message.message.content.count
            case .failure(let error):
                if self?.messages.isEmpty == false {
                    let lastMessage = self?.messages.removeLast()
                    self?.view?.showError(text: error.localizedDescription)
                    self?.view?.setTextField(text: lastMessage?.text ?? "") // TODO не удалось отправить сообшение
                }
            }
            
            self?.showWriting = false
        }
    }
}

extension UserDefaults {
    static private let key = "Incoming Token Limit" // TODO save to keychain
    
    static var incomingTokenLimit: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        } get {
            let value = UserDefaults.standard.value(forKey: key) as? Int
            return value ?? 0
        }
    }
}

extension UserDefaults {
    static private let outgoingKey = "Outgoing Token Limit" // TODO save to keychain
    
    static var outgoingTokenLimit: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: outgoingKey)
        } get {
            let value = UserDefaults.standard.value(forKey: outgoingKey) as? Int
            return value ?? 0
        }
    }
}





















fileprivate let textMessage: [MessageModelViewModel] = [
    .init(text: "123123", isUserMessage: true, date: Date()),
    .init(text: "Testadstas tas", isUserMessage: false, date: Date()),
    .init(text: "Testadstas\ntas", isUserMessage: true, date: Date()),
    .init(text: "Testadstas\ntas", isUserMessage: false, date: Date()),
    .init(text: "2", isUserMessage: false, date: Date()),
    .init(text: "2", isUserMessage: true, date: Date()),
    .init(text: "123123", isUserMessage: true, date: Date()),
    .init(text: "Testadstas tas", isUserMessage: false, date: Date()),
    .init(text: "Testadstas\ntas", isUserMessage: true, date: Date()),
    .init(text: "Testadstas\ntas", isUserMessage: false, date: Date()),
    .init(text: "2", isUserMessage: false, date: Date()),
    .init(text: "2", isUserMessage: true, date: Date()),
    .init(text: "123123", isUserMessage: true, date: Date()),
    .init(text: "Testadstas tas", isUserMessage: false, date: Date()),
    .init(text: "Testadstas\ntas", isUserMessage: true, date: Date()),
    .init(text: "Testadstas\ntas", isUserMessage: false, date: Date()),
    .init(text: "2", isUserMessage: false, date: Date()),
    .init(text: "2", isUserMessage: true, date: Date()),
]

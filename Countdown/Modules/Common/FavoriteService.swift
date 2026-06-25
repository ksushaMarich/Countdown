import Foundation

enum FavoriteServiceKey: String {
    case chats = "213sadasdsadj"
}

class FavoriteService<Item: Codable & Equatable>  {
    private let key: FavoriteServiceKey
    
    init(key: FavoriteServiceKey) {
        self.key = key
    }
    
    var favorites: [Item] {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key.rawValue)
            }
        } get {
            if let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data,
               let favorites = try? JSONDecoder().decode([Item].self, from: data) {
                 return favorites
            }
            
            return []
        }
    }
    
    func add(_ item: Item) {
        if favorites.isEmpty {
            favorites = [item]
        } else {
            favorites.append(item)
        }
    }
    
    func remove(_ item: Item) {
        guard let deleteIndex = favorites.firstIndex(where: { $0 == item }) else { return }
        favorites.remove(at: deleteIndex)
    }
}

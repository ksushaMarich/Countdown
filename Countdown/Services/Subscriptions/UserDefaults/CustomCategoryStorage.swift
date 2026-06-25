
import Foundation

struct CustomCategoryModel: Codable {
    let name: String
    let colorIndex: Int
}

final class CustomCategoryStorage {
    
    static let shared = CustomCategoryStorage()
    private init() {}
    
    private let key = "customCategories"
    
    func addCategory(_ category: CustomCategoryModel) {
        var categories = loadCategories()
        categories.append(category)
        
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadCategories() -> [CustomCategoryModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([CustomCategoryModel].self, from: data) else {
            return []
        }
        return decoded
    }
}


import Foundation

struct RepeatOptionModel: Codable, Equatable {
    let id: String
    let repeatOption: String
}

final class RepeatOptionsStore {
    
    static let shared = RepeatOptionsStore()
    private init() {}
    
    private let suiteName = "group.com.metamodern.countdown"
    private let key = "RepeatOptionsStore"
    
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: suiteName)
    }
    
    func save(_ option: RepeatOptionModel) {
        var options = fetchAll()
        
        if let index = options.firstIndex(where: { $0.id == option.id }) {
            options[index] = option
        } else {
            options.append(option)
        }
        
        saveAll(options)
    }
    
    func get(by id: String) -> RepeatOptionModel? {
        return fetchAll().first(where: { $0.id == id })
    }
    
    func remove(by id: String) {
        var options = fetchAll()
        options.removeAll { $0.id == id }
        saveAll(options)
    }
    
    private func fetchAll() -> [RepeatOptionModel] {
        guard let data = userDefaults?.data(forKey: key),
              let options = try? JSONDecoder().decode([RepeatOptionModel].self, from: data)
        else {
            return []
        }
        return options
    }
    
    private func saveAll(_ options: [RepeatOptionModel]) {
        guard let data = try? JSONEncoder().encode(options) else { return }
        userDefaults?.set(data, forKey: key)
    }
}

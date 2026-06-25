import Alamofire

enum ApiConstants {
    static let gptModel = "gpt-3.5-turbo"
    static let apiKey = "<YOUR_OPENAI_API_KEY>"
}

struct SendBody: Codable {
    let model: String
    let messages: [MessageModel]
}

class ChatNetworkService {
    func send(
        message: MessageModel,
        history: [MessageModel],
        prompt: String,
        completion: @escaping ((Result<SendMessage, Error>) -> Void)
    ) {
        let headers = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(String(describing: ApiConstants.apiKey))",
        ]
        
        var messages = history + [message]
        messages.insert(.init(role: .system, content: prompt), at: 0)
        
        let body = SendBody(
            model: ApiConstants.gptModel,
            messages: messages
        )
        do {
            let jsonData = try JSONEncoder().encode(body)
            
            AF.upload(
                jsonData,
                to: "https://api.openai.com/v1/chat/completions",
                method: .post,
                headers: HTTPHeaders(headers)
            ) { $0.timeoutInterval = 10 }
            .responseData { data in
                if let data = data.data {
                    do {
                        let sendMessage = try JSONDecoder().decode(SendMessage.self, from: data)
                        completion(.success(sendMessage))
                    } catch {
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("<<< ChatNetworkService.send decode error, json: \(String(describing: json))")
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(
                        data.error ?? NSError(domain: "ChatNetworkService", code: 123))
                    )
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

}

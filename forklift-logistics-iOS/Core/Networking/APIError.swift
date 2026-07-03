import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverStatus(Int)
    case decodingFailed
    case encodingFailed
    case transport(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес сервера."
        case .invalidResponse:
            return "Сервер вернул некорректный ответ."
        case .serverStatus(let code):
            return "Ошибка сервера: HTTP \(code)."
        case .decodingFailed:
            return "Не удалось прочитать ответ сервера."
        case .encodingFailed:
            return "Не удалось подготовить запрос."
        case .transport(let error):
            return error.localizedDescription
        }
    }
}

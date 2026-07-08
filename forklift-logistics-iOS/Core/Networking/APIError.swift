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
            return AppConstants.Text.APIError.invalidURL
        case .invalidResponse:
            return AppConstants.Text.APIError.invalidResponse
        case .serverStatus(let code):
            return "\(AppConstants.Text.APIError.serverStatusPrefix) \(code)."
        case .decodingFailed:
            return AppConstants.Text.APIError.decodingFailed
        case .encodingFailed:
            return AppConstants.Text.APIError.encodingFailed
        case .transport(let error):
            return error.localizedDescription
        }
    }
}

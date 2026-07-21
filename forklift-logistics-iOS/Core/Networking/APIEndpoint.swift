import Foundation

struct APIEndpoint {
    let path: String
    let method: HTTPMethod

    static let compare = APIEndpoint(path: AppConstants.API.comparePath, method: .post)
}

enum HTTPMethod: String {
    case post = "POST"
}

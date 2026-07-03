import Foundation

struct APIEndpoint {
    let path: String
    let method: HTTPMethod

    static let compare = APIEndpoint(path: "/compare", method: .post)
    static let health = APIEndpoint(path: "/health", method: .get)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

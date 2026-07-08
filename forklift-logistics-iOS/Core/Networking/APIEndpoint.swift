import Foundation

struct APIEndpoint {
    let path: String
    let method: HTTPMethod

    static let compareSummary = APIEndpoint(path: AppConstants.API.compareSummaryPath, method: .post)
    static let compareRoutes = APIEndpoint(path: AppConstants.API.compareRoutesPath, method: .post)
    static let compareTrips = APIEndpoint(path: AppConstants.API.compareTripsPath, method: .post)
}

enum HTTPMethod: String {
    case post = "POST"
}

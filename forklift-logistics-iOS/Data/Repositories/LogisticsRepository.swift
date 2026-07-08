import Foundation

final class LogisticsRepository: LogisticsRepositoryProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func compareSummary(settings: ScenarioSettings) async throws -> CompareResult {
        try await compare(settings: settings, endpoint: .compareSummary)
    }

    func compareRoutes(settings: ScenarioSettings) async throws -> CompareResult {
        try await compare(settings: settings, endpoint: .compareRoutes)
    }

    func compareTrips(settings: ScenarioSettings) async throws -> CompareResult {
        try await compare(settings: settings, endpoint: .compareTrips)
    }

    private func compare(settings: ScenarioSettings, endpoint: APIEndpoint) async throws -> CompareResult {
        let request = CompareMapper.request(from: settings)
        let response: CompareResponseDTO = try await httpClient.send(endpoint, body: request)
        return CompareMapper.map(response)
    }
}

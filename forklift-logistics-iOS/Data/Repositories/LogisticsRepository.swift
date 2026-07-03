import Foundation

final class LogisticsRepository: LogisticsRepositoryProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func compare(settings: ScenarioSettings) async throws -> CompareResult {
        let request = CompareMapper.request(from: settings)
        let response: CompareResponseDTO = try await httpClient.send(.compare, body: request)
        return CompareMapper.map(response)
    }
}

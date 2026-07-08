import Foundation

protocol CompareStrategiesUseCaseProtocol {
    func executeSummary(settings: ScenarioSettings) async throws -> CompareResult
    func executeRoutes(settings: ScenarioSettings) async throws -> CompareResult
    func executeTrips(settings: ScenarioSettings) async throws -> CompareResult
}

final class CompareStrategiesUseCase: CompareStrategiesUseCaseProtocol {
    private let repository: LogisticsRepositoryProtocol

    init(repository: LogisticsRepositoryProtocol) {
        self.repository = repository
    }

    func executeSummary(settings: ScenarioSettings) async throws -> CompareResult {
        try await repository.compareSummary(settings: settings)
    }

    func executeRoutes(settings: ScenarioSettings) async throws -> CompareResult {
        try await repository.compareRoutes(settings: settings)
    }

    func executeTrips(settings: ScenarioSettings) async throws -> CompareResult {
        try await repository.compareTrips(settings: settings)
    }
}

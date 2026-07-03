import Foundation

protocol CompareStrategiesUseCaseProtocol {
    func execute(settings: ScenarioSettings) async throws -> CompareResult
}

final class CompareStrategiesUseCase: CompareStrategiesUseCaseProtocol {
    private let repository: LogisticsRepositoryProtocol

    init(repository: LogisticsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(settings: ScenarioSettings) async throws -> CompareResult {
        try await repository.compare(settings: settings)
    }
}

import Foundation

protocol LogisticsRepositoryProtocol {
    func compare(settings: ScenarioSettings) async throws -> CompareResult
}

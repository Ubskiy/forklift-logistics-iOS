import Foundation

protocol LogisticsRepositoryProtocol {
    func compareSummary(settings: ScenarioSettings) async throws -> CompareResult
    func compareRoutes(settings: ScenarioSettings) async throws -> CompareResult
    func compareTrips(settings: ScenarioSettings) async throws -> CompareResult
}

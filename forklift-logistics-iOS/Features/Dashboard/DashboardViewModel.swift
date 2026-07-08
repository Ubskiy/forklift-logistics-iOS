import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {
    var settings = ScenarioSettings()
    var result: CompareResult?
    var isLoading = false
    var isLoadingRoutes = false
    var isLoadingTrips = false
    var errorMessage: String?
    var selectedStrategy: StrategySelector = .annealing

    private let compareUseCase: CompareStrategiesUseCaseProtocol

    init(compareUseCase: CompareStrategiesUseCaseProtocol) {
        self.compareUseCase = compareUseCase
    }

    func runCalculation() async {
        isLoading = true
        errorMessage = nil
        result = nil
        defer { isLoading = false }

        do {
            result = try await compareUseCase.executeSummary(settings: settings)
            selectedStrategy = .annealing
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadRoutesIfNeeded() async {
        guard !isLoadingRoutes, let result, result.greedy.routeStats.isEmpty || result.annealing.routeStats.isEmpty else { return }
        isLoadingRoutes = true
        defer { isLoadingRoutes = false }

        do {
            let details = try await compareUseCase.executeRoutes(settings: settings)
            merge(details: details, includeRoutes: true, includeTrips: false)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadTripsIfNeeded() async {
        guard !isLoadingTrips, let result, result.greedy.tripLog.isEmpty || result.annealing.tripLog.isEmpty else { return }
        isLoadingTrips = true
        defer { isLoadingTrips = false }

        do {
            let details = try await compareUseCase.executeTrips(settings: settings)
            merge(details: details, includeRoutes: false, includeTrips: true)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func merge(details: CompareResult, includeRoutes: Bool, includeTrips: Bool) {
        guard let current = result else { return }
        result = CompareResult(
            scenario: current.scenario,
            greedy: current.greedy.mergingDetails(from: details.greedy, includeRoutes: includeRoutes, includeTrips: includeTrips),
            annealing: current.annealing.mergingDetails(from: details.annealing, includeRoutes: includeRoutes, includeTrips: includeTrips),
            delta: current.delta
        )
    }
}

enum StrategySelector: String, CaseIterable, Identifiable {
    case greedy
    case annealing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .greedy: return AppConstants.Text.Common.greedyShort
        case .annealing: return AppConstants.Text.Common.annealingShort
        }
    }
}

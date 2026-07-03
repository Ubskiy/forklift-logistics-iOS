import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {
    var settings = ScenarioSettings()
    var result: CompareResult?
    var isLoading = false
    var errorMessage: String?
    var selectedStrategy: StrategySelector = .annealing

    private let compareUseCase: CompareStrategiesUseCaseProtocol

    init(compareUseCase: CompareStrategiesUseCaseProtocol) {
        self.compareUseCase = compareUseCase
    }

    func runCalculation() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            result = try await compareUseCase.execute(settings: settings)
            selectedStrategy = .annealing
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

enum StrategySelector: String, CaseIterable, Identifiable {
    case greedy
    case annealing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .greedy: return "Жадная"
        case .annealing: return "Отжиг"
        }
    }
}

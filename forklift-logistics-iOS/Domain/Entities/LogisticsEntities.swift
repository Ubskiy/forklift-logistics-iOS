import Foundation

struct ScenarioSettings: Equatable {
    var scenario: ScenarioKind = .day
    var orderShieldsQty: Int = 88
    var shiftDurationHours: Double = 11
    var iterations: Int = 120
    var seed: Int = 42
    var c3RatePerHour: Double = 8
    var initialC2: Int = 2
    var initialC3: Int = 0
    var initialC4: Int = 0

    var requestID: String { scenario.rawValue }
}

enum ScenarioKind: String, CaseIterable, Identifiable {
    case day = "sample_day"
    case night = "sample_night"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .day: return "Дневная смена"
        case .night: return "Ночная смена"
        }
    }
}

struct CompareResult: Equatable {
    let scenario: ScenarioSummary
    let greedy: StrategyResult
    let annealing: StrategyResult
    let delta: CompareDelta
}

struct ScenarioSummary: Equatable {
    let name: String
    let shiftType: String
    let shiftStart: String
    let shiftDurationHours: Double
    let orderShieldsQty: Int
}

struct StrategyResult: Equatable, Identifiable {
    var id: String { strategyName }
    let strategyName: String
    let title: String
    let metrics: StrategyMetrics
    let routeStats: [RouteStat]
    let tripLog: [TripRecord]
}

struct StrategyMetrics: Equatable {
    let objectiveValue: Double
    let makespanMin: Double
    let makespanHMS: String
    let c3StarvationMin: Double
    let c3StarvationHMS: String
    let shippedQty: Double
    let shortfallQty: Double
    let tripsTotal: Int
    let avgTripLoadUnits: Double
    let avgTripLoadFactor: Double
    let avgForkliftUtilization: Double
    let emptyTravelTotalMin: Double
}

struct RouteStat: Equatable, Identifiable {
    var id: String { route }
    let route: String
    let tripsCount: Int
    let shieldsQty: Double
    let tubesQty: Double
    let totalWeightKg: Double
    let totalDurationMin: Double
    let avgTripSize: Double
    let tripsSharePct: Double
    let volumeSharePct: Double
}

struct TripRecord: Equatable, Identifiable {
    var id: String { "\(strategyName)-\(tripID)" }
    let strategyName: String
    let forkliftID: String
    let tripID: Int
    let cargoType: String
    let route: String
    let qty: Double
    let totalWeight: Double
    let startTimeMin: Double
    let endTimeMin: Double
    let durationMinutes: Double
    let interval: String
    let loadInterval: String
    let travelInterval: String
    let unloadInterval: String
    let emptyTravelMinutes: Double
}

struct CompareDelta: Equatable {
    let shippedQty: Double
    let shortfallQty: Double
    let objectiveValue: Double
    let c3StarvationMin: Double
    let tripsTotal: Double
}

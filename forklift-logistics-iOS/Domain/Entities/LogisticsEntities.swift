import Foundation

struct ScenarioSettings: Equatable {
    var scenario: ScenarioKind = .day
    var orderShieldsQty: Int = 88
    var shiftDurationHours: Double = 11

    var sourceTubes: Int = 352
    var initialTubesAtC1: Int = 8
    var initialC2: Int = 2
    var initialC3: Int = 0
    var initialC4: Int = 0

    var tubeLoadMin: Double = 5
    var tubeUnloadMin: Double = 4
    var shieldLoadMin: Double = 5
    var shieldUnloadMin: Double = 4
    var finishedLoadMin: Double = 5
    var finishedUnloadMin: Double = 4

    var travelSC1: Double = 1
    var travelC1C2: Double = 1
    var travelC2C3: Double = 1
    var travelC3C4: Double = 1
    var travelC4P: Double = 1

    var c1RatePerHour: Double = 8
    var c2RatePerHour: Double = 12
    var c3RatePerHour: Double = 8
    var c4RatePerHour: Double = 12

    var underproductionPenalty: Double = 15000
    var makespanWeight: Double = 1
    var c3StarvationWeight: Double = 25
    var forkliftIdleWeight: Double = 4

    var iterations: Int = 120
    var initialTemperature: Double = 20000
    var coolingRate: Double = 0.985
    var minTemperature: Double = 0.1
    var seed: Int = 42

    var requestID: String { scenario.rawValue }
}

enum ScenarioKind: String, CaseIterable, Identifiable {
    case day = "sample_day"
    case night = "sample_night"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .day: return AppConstants.Text.Scenario.dayShift
        case .night: return AppConstants.Text.Scenario.nightShift
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

    func mergingDetails(from other: StrategyResult, includeRoutes: Bool, includeTrips: Bool) -> StrategyResult {
        StrategyResult(
            strategyName: strategyName,
            title: title,
            metrics: metrics,
            routeStats: includeRoutes ? other.routeStats : routeStats,
            tripLog: includeTrips ? other.tripLog : tripLog
        )
    }
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

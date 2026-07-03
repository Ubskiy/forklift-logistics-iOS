import Foundation

struct CompareRequestDTO: Encodable {
    let scenario: String
    let orderShieldsQty: Int
    let shiftDurationHours: Double
    let initialInventory: InitialInventoryDTO
    let production: ProductionDTO
    let annealing: AnnealingDTO

    enum CodingKeys: String, CodingKey {
        case scenario
        case orderShieldsQty = "order_shields_qty"
        case shiftDurationHours = "shift_duration_hours"
        case initialInventory = "initial_inventory"
        case production
        case annealing
    }
}

struct InitialInventoryDTO: Encodable {
    let shieldsWaitingC2: Int
    let shieldsWaitingC3: Int
    let finishedWaitingC4: Int

    enum CodingKeys: String, CodingKey {
        case shieldsWaitingC2 = "shields_waiting_c2"
        case shieldsWaitingC3 = "shields_waiting_c3"
        case finishedWaitingC4 = "finished_waiting_c4"
    }
}

struct ProductionDTO: Encodable {
    let c3PerHour: Double

    enum CodingKeys: String, CodingKey {
        case c3PerHour = "c3_per_hour"
    }
}

struct AnnealingDTO: Encodable {
    let iterations: Int
    let seed: Int
}

struct CompareResponseDTO: Decodable {
    let scenario: ScenarioSummaryDTO
    let greedy: StrategyResultDTO
    let simulatedAnnealing: StrategyResultDTO
    let delta: CompareDeltaDTO

    enum CodingKeys: String, CodingKey {
        case scenario
        case greedy
        case simulatedAnnealing = "simulated_annealing"
        case delta
    }
}

struct ScenarioSummaryDTO: Decodable {
    let name: String
    let shiftType: String
    let shiftStartHHMM: String
    let shiftDurationHours: Double
    let orderShieldsQty: Int

    enum CodingKeys: String, CodingKey {
        case name
        case shiftType = "shift_type"
        case shiftStartHHMM = "shift_start_hhmm"
        case shiftDurationHours = "shift_duration_hours"
        case orderShieldsQty = "order_shields_qty"
    }
}

struct StrategyResultDTO: Decodable {
    let strategyName: String
    let metrics: MetricsDTO
    let routeStats: [RouteStatDTO]
    let tripLog: [TripRecordDTO]

    enum CodingKeys: String, CodingKey {
        case strategyName = "strategy_name"
        case metrics
        case routeStats = "route_stats"
        case tripLog = "trip_log"
    }
}

struct MetricsDTO: Decodable {
    let makespanMin: Double
    let c3StarvationMin: Double
    let shortfallQty: Double
    let shippedQty: Double
    let tripsTotal: Int
    let avgTripLoadUnits: Double
    let avgTripLoadFactor: Double
    let avgForkliftUtilization: Double
    let emptyTravelTotalMin: Double
    let objectiveValue: Double
    let makespanHMS: String
    let c3StarvationHMS: String

    enum CodingKeys: String, CodingKey {
        case makespanMin = "makespan_min"
        case c3StarvationMin = "c3_starvation_min"
        case shortfallQty = "shortfall_qty"
        case shippedQty = "shipped_qty"
        case tripsTotal = "trips_total"
        case avgTripLoadUnits = "avg_trip_load_units"
        case avgTripLoadFactor = "avg_trip_load_factor"
        case avgForkliftUtilization = "avg_forklift_utilization"
        case emptyTravelTotalMin = "empty_travel_total_min"
        case objectiveValue = "objective_value"
        case makespanHMS = "makespan_hms"
        case c3StarvationHMS = "c3_starvation_hms"
    }
}

struct RouteStatDTO: Decodable {
    let route: String
    let tripsCount: Int
    let shieldsQty: Double
    let tubesQty: Double
    let totalWeightKg: Double
    let totalDurationMin: Double
    let avgTripSize: Double
    let tripsSharePct: Double
    let volumeSharePct: Double

    enum CodingKeys: String, CodingKey {
        case route
        case tripsCount = "trips_count"
        case shieldsQty = "shields_qty"
        case tubesQty = "tubes_qty"
        case totalWeightKg = "total_weight_kg"
        case totalDurationMin = "total_duration_min"
        case avgTripSize = "avg_trip_size"
        case tripsSharePct = "trips_share_pct"
        case volumeSharePct = "volume_share_pct"
    }
}

struct TripRecordDTO: Decodable {
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

    enum CodingKeys: String, CodingKey {
        case strategyName = "strategy_name"
        case forkliftID = "forklift_id"
        case tripID = "trip_id"
        case cargoType = "cargo_type"
        case route
        case qty
        case totalWeight = "total_weight"
        case startTimeMin = "start_time_min"
        case endTimeMin = "end_time_min"
        case durationMinutes = "duration_minutes"
        case interval
        case loadInterval = "load_interval"
        case travelInterval = "travel_interval"
        case unloadInterval = "unload_interval"
        case emptyTravelMinutes = "empty_travel_minutes"
    }
}

struct CompareDeltaDTO: Decodable {
    let shippedQty: Double
    let shortfallQty: Double
    let objectiveValue: Double
    let c3StarvationMin: Double
    let tripsTotal: Double

    enum CodingKeys: String, CodingKey {
        case shippedQty = "shipped_qty"
        case shortfallQty = "shortfall_qty"
        case objectiveValue = "objective_value"
        case c3StarvationMin = "c3_starvation_min"
        case tripsTotal = "trips_total"
    }
}

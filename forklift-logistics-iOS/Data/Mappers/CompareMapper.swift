import Foundation

enum CompareMapper {
    static func request(from settings: ScenarioSettings) -> CompareRequestDTO {
        CompareRequestDTO(
            scenario: settings.scenario.rawValue,
            orderShieldsQty: settings.orderShieldsQty,
            shiftDurationHours: settings.shiftDurationHours,
            initialInventory: InitialInventoryDTO(
                sourceTubes: settings.sourceTubes,
                tubesAtC1: settings.initialTubesAtC1,
                shieldsWaitingC2: settings.initialC2,
                shieldsWaitingC3: settings.initialC3,
                finishedWaitingC4: settings.initialC4
            ),
            handling: HandlingTimesDTO(
                tubeLoadMin: settings.tubeLoadMin,
                tubeUnloadMin: settings.tubeUnloadMin,
                shieldLoadMin: settings.shieldLoadMin,
                shieldUnloadMin: settings.shieldUnloadMin,
                finishedLoadMin: settings.finishedLoadMin,
                finishedUnloadMin: settings.finishedUnloadMin
            ),
            travelTimes: TravelTimesDTO(
                sC1: settings.travelSC1,
                c1C2: settings.travelC1C2,
                c2C3: settings.travelC2C3,
                c3C4: settings.travelC3C4,
                c4P: settings.travelC4P
            ),
            production: ProductionDTO(
                c1PerHour: settings.c1RatePerHour,
                c2PerHour: settings.c2RatePerHour,
                c3PerHour: settings.c3RatePerHour,
                c4PerHour: settings.c4RatePerHour
            ),
            objective: ObjectiveWeightsDTO(
                underproductionPenalty: settings.underproductionPenalty,
                makespanWeight: settings.makespanWeight,
                c3StarvationWeight: settings.c3StarvationWeight,
                forkliftIdleWeight: settings.forkliftIdleWeight
            ),
            annealing: AnnealingDTO(
                iterations: settings.iterations,
                initialTemperature: settings.initialTemperature,
                coolingRate: settings.coolingRate,
                minTemperature: settings.minTemperature,
                seed: settings.seed
            )
        )
    }

    static func map(_ dto: CompareResponseDTO) -> CompareResult {
        CompareResult(
            scenario: ScenarioSummary(
                name: dto.scenario.name,
                shiftType: dto.scenario.shiftType,
                shiftStart: dto.scenario.shiftStartHHMM,
                shiftDurationHours: dto.scenario.shiftDurationHours,
                orderShieldsQty: dto.scenario.orderShieldsQty
            ),
            greedy: strategy(dto.greedy, title: AppConstants.Text.Common.greedyFull),
            annealing: strategy(dto.simulatedAnnealing, title: AppConstants.Text.Common.annealingFull),
            delta: CompareDelta(
                shippedQty: dto.delta.shippedQty,
                shortfallQty: dto.delta.shortfallQty,
                objectiveValue: dto.delta.objectiveValue,
                c3StarvationMin: dto.delta.c3StarvationMin,
                tripsTotal: dto.delta.tripsTotal
            )
        )
    }

    private static func strategy(_ dto: StrategyResultDTO, title: String) -> StrategyResult {
        StrategyResult(
            strategyName: dto.strategyName,
            title: title,
            metrics: StrategyMetrics(
                objectiveValue: dto.metrics.objectiveValue,
                makespanMin: dto.metrics.makespanMin,
                makespanHMS: dto.metrics.makespanHMS,
                c3StarvationMin: dto.metrics.c3StarvationMin,
                c3StarvationHMS: dto.metrics.c3StarvationHMS,
                shippedQty: dto.metrics.shippedQty,
                shortfallQty: dto.metrics.shortfallQty,
                tripsTotal: dto.metrics.tripsTotal,
                avgTripLoadUnits: dto.metrics.avgTripLoadUnits,
                avgTripLoadFactor: dto.metrics.avgTripLoadFactor,
                avgForkliftUtilization: dto.metrics.avgForkliftUtilization,
                emptyTravelTotalMin: dto.metrics.emptyTravelTotalMin
            ),
            routeStats: dto.routeStats.map {
                RouteStat(
                    route: $0.route,
                    tripsCount: $0.tripsCount,
                    shieldsQty: $0.shieldsQty,
                    tubesQty: $0.tubesQty,
                    totalWeightKg: $0.totalWeightKg,
                    totalDurationMin: $0.totalDurationMin,
                    avgTripSize: $0.avgTripSize,
                    tripsSharePct: $0.tripsSharePct,
                    volumeSharePct: $0.volumeSharePct
                )
            },
            tripLog: dto.tripLog.map {
                TripRecord(
                    strategyName: $0.strategyName,
                    forkliftID: $0.forkliftID,
                    tripID: $0.tripID,
                    cargoType: $0.cargoType,
                    route: $0.route,
                    qty: $0.qty,
                    totalWeight: $0.totalWeight,
                    startTimeMin: $0.startTimeMin,
                    endTimeMin: $0.endTimeMin,
                    durationMinutes: $0.durationMinutes,
                    interval: $0.interval,
                    loadInterval: $0.loadInterval,
                    travelInterval: $0.travelInterval,
                    unloadInterval: $0.unloadInterval,
                    emptyTravelMinutes: $0.emptyTravelMinutes
                )
            }
        )
    }
}

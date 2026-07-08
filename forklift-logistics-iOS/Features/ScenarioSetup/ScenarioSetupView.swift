import SwiftUI

struct ScenarioSetupView: View {
    @Binding var settings: ScenarioSettings

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.Layout.screenSpacing) {
                shiftSection
                dispatcherTip
                inventorySection
                handlingSection
                travelSection
                productionSection
                objectiveSection
                annealingSection
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(AppConstants.Text.Common.scenario)
    }

    private var shiftSection: some View {
        SectionCard(AppConstants.Text.Scenario.settingsTitle, subtitle: AppConstants.Text.Scenario.settingsSubtitle) {
            Picker(AppConstants.Text.Common.scenario, selection: $settings.scenario) {
                ForEach(ScenarioKind.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .pickerStyle(.segmented)

            Stepper("\(AppConstants.Text.Scenario.plan): \(settings.orderShieldsQty) \(AppConstants.Text.Common.shieldsUnit)", value: $settings.orderShieldsQty, in: AppConstants.ScenarioLimits.planRange, step: AppConstants.ScenarioLimits.planStep)
            Stepper("\(AppConstants.Text.Scenario.duration): \(NumberFormatting.two(settings.shiftDurationHours)) \(AppConstants.Time.hourUnit)", value: $settings.shiftDurationHours, in: AppConstants.ScenarioLimits.durationRange, step: AppConstants.ScenarioLimits.durationStep)
        }
    }

    private var dispatcherTip: some View {
        InfoTipView(
            title: AppConstants.Text.Scenario.dispatcherTipTitle,
            message: AppConstants.Text.Scenario.dispatcherTipMessage
        )
    }

    private var inventorySection: some View {
        SectionCard(AppConstants.Text.Scenario.initialInventoryTitle, subtitle: AppConstants.Text.Scenario.initialInventorySubtitle) {
            Stepper("\(AppConstants.Text.Scenario.sourceTubes): \(settings.sourceTubes)", value: $settings.sourceTubes, in: AppConstants.ScenarioLimits.sourceTubesRange)
            Stepper("\(AppConstants.Text.Scenario.tubesAtC1): \(settings.initialTubesAtC1)", value: $settings.initialTubesAtC1, in: AppConstants.ScenarioLimits.c1TubesRange)
            Stepper("\(AppConstants.Text.Scenario.shieldsAtC2): \(settings.initialC2)", value: $settings.initialC2, in: AppConstants.ScenarioLimits.inventoryRange)
            Stepper("\(AppConstants.Text.Scenario.shieldsAtC3): \(settings.initialC3)", value: $settings.initialC3, in: AppConstants.ScenarioLimits.inventoryRange)
            Stepper("\(AppConstants.Text.Scenario.finishedAtC4): \(settings.initialC4)", value: $settings.initialC4, in: AppConstants.ScenarioLimits.inventoryRange)
        }
    }

    private var handlingSection: some View {
        SectionCard(AppConstants.Text.Scenario.handlingTitle, subtitle: AppConstants.Text.Scenario.handlingSubtitle) {
            doubleStepper(AppConstants.Text.Scenario.tubeLoad, value: $settings.tubeLoadMin, range: AppConstants.ScenarioLimits.handlingRange, step: AppConstants.ScenarioLimits.handlingStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Text.Scenario.tubeUnload, value: $settings.tubeUnloadMin, range: AppConstants.ScenarioLimits.handlingRange, step: AppConstants.ScenarioLimits.handlingStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Text.Scenario.shieldLoad, value: $settings.shieldLoadMin, range: AppConstants.ScenarioLimits.handlingRange, step: AppConstants.ScenarioLimits.handlingStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Text.Scenario.shieldUnload, value: $settings.shieldUnloadMin, range: AppConstants.ScenarioLimits.handlingRange, step: AppConstants.ScenarioLimits.handlingStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Text.Scenario.finishedLoad, value: $settings.finishedLoadMin, range: AppConstants.ScenarioLimits.handlingRange, step: AppConstants.ScenarioLimits.handlingStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Text.Scenario.finishedUnload, value: $settings.finishedUnloadMin, range: AppConstants.ScenarioLimits.handlingRange, step: AppConstants.ScenarioLimits.handlingStep, unit: AppConstants.Time.minuteUnit)
        }
    }

    private var travelSection: some View {
        SectionCard(AppConstants.Text.Scenario.travelTitle, subtitle: AppConstants.Text.Scenario.travelSubtitle) {
            doubleStepper(AppConstants.Route.sC1, value: $settings.travelSC1, range: AppConstants.ScenarioLimits.travelRange, step: AppConstants.ScenarioLimits.travelStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Route.c1C2, value: $settings.travelC1C2, range: AppConstants.ScenarioLimits.travelRange, step: AppConstants.ScenarioLimits.travelStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Route.c2C3, value: $settings.travelC2C3, range: AppConstants.ScenarioLimits.travelRange, step: AppConstants.ScenarioLimits.travelStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Route.c3C4, value: $settings.travelC3C4, range: AppConstants.ScenarioLimits.travelRange, step: AppConstants.ScenarioLimits.travelStep, unit: AppConstants.Time.minuteUnit)
            doubleStepper(AppConstants.Route.c4P, value: $settings.travelC4P, range: AppConstants.ScenarioLimits.travelRange, step: AppConstants.ScenarioLimits.travelStep, unit: AppConstants.Time.minuteUnit)
        }
    }

    private var productionSection: some View {
        SectionCard(AppConstants.Text.Scenario.productionTitle, subtitle: AppConstants.Text.Scenario.productionSubtitle) {
            doubleStepper(AppConstants.Text.Scenario.c1, value: $settings.c1RatePerHour, range: AppConstants.ScenarioLimits.productionRateRange, step: AppConstants.ScenarioLimits.c3RateStep, unit: AppConstants.Text.Scenario.shieldsPerHour)
            doubleStepper(AppConstants.Text.Scenario.c2, value: $settings.c2RatePerHour, range: AppConstants.ScenarioLimits.productionRateRange, step: AppConstants.ScenarioLimits.c3RateStep, unit: AppConstants.Text.Scenario.shieldsPerHour)
            doubleStepper(AppConstants.Text.Scenario.c3, value: $settings.c3RatePerHour, range: AppConstants.ScenarioLimits.c3RateRange, step: AppConstants.ScenarioLimits.c3RateStep, unit: AppConstants.Text.Scenario.shieldsPerHour)
            doubleStepper(AppConstants.Text.Scenario.c4, value: $settings.c4RatePerHour, range: AppConstants.ScenarioLimits.productionRateRange, step: AppConstants.ScenarioLimits.c3RateStep, unit: AppConstants.Text.Scenario.shieldsPerHour)
        }
    }

    private var objectiveSection: some View {
        SectionCard(AppConstants.Text.Scenario.objectiveTitle, subtitle: AppConstants.Text.Scenario.objectiveSubtitle) {
            doubleStepper(AppConstants.Text.Scenario.underproductionPenalty, value: $settings.underproductionPenalty, range: AppConstants.ScenarioLimits.underproductionPenaltyRange, step: AppConstants.ScenarioLimits.underproductionPenaltyStep)
            doubleStepper(AppConstants.Text.Scenario.makespanWeight, value: $settings.makespanWeight, range: AppConstants.ScenarioLimits.makespanWeightRange, step: AppConstants.ScenarioLimits.makespanWeightStep)
            doubleStepper(AppConstants.Text.Scenario.c3StarvationWeight, value: $settings.c3StarvationWeight, range: AppConstants.ScenarioLimits.c3StarvationWeightRange, step: AppConstants.ScenarioLimits.c3StarvationWeightStep)
            doubleStepper(AppConstants.Text.Scenario.forkliftIdleWeight, value: $settings.forkliftIdleWeight, range: AppConstants.ScenarioLimits.forkliftIdleWeightRange, step: AppConstants.ScenarioLimits.forkliftIdleWeightStep)
        }
    }

    private var annealingSection: some View {
        SectionCard(AppConstants.Text.Scenario.annealingTitle, subtitle: AppConstants.Text.Scenario.annealingSubtitle) {
            Stepper("\(AppConstants.Text.Scenario.iterations): \(settings.iterations)", value: $settings.iterations, in: AppConstants.ScenarioLimits.iterationsRange, step: AppConstants.ScenarioLimits.iterationsStep)
            doubleStepper(AppConstants.Text.Scenario.initialTemperature, value: $settings.initialTemperature, range: AppConstants.ScenarioLimits.initialTemperatureRange, step: AppConstants.ScenarioLimits.initialTemperatureStep)
            doubleStepper(AppConstants.Text.Scenario.coolingRate, value: $settings.coolingRate, range: AppConstants.ScenarioLimits.coolingRateRange, step: AppConstants.ScenarioLimits.coolingRateStep)
            doubleStepper(AppConstants.Text.Scenario.minTemperature, value: $settings.minTemperature, range: AppConstants.ScenarioLimits.minTemperatureRange, step: AppConstants.ScenarioLimits.minTemperatureStep)
            Stepper("\(AppConstants.Text.Scenario.seed): \(settings.seed)", value: $settings.seed, in: AppConstants.ScenarioLimits.seedRange)
        }
    }

    private func doubleStepper(_ title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, unit: String? = nil) -> some View {
        let suffix = unit.map { " \($0)" } ?? AppConstants.NumberFormat.empty
        return Stepper("\(title): \(NumberFormatting.two(value.wrappedValue))\(suffix)", value: value, in: range, step: step)
    }
}

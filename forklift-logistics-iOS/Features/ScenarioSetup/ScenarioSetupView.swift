import SwiftUI

struct ScenarioSetupView: View {
    @Binding var settings: ScenarioSettings
    @FocusState private var focusedField: ScenarioField?
    @State private var isResetConfirmationPresented = false

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
        .appScreen(title: AppConstants.Text.Common.scenario)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(AppConstants.Text.Scenario.reset) {
                    isResetConfirmationPresented = true
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    moveFocus(by: -1)
                } label: {
                    Image(systemName: "chevron.up")
                }
                .disabled(focusedField == ScenarioField.allCases.first)
                .accessibilityLabel(AppConstants.Text.Scenario.previousField)

                Button {
                    moveFocus(by: 1)
                } label: {
                    Image(systemName: "chevron.down")
                }
                .disabled(focusedField == ScenarioField.allCases.last)
                .accessibilityLabel(AppConstants.Text.Scenario.nextField)

                Spacer()

                Button(AppConstants.Text.Scenario.done) {
                    focusedField = nil
                }
                .fontWeight(.semibold)
            }
        }
        .confirmationDialog(
            AppConstants.Text.Scenario.resetConfirmationTitle,
            isPresented: $isResetConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(AppConstants.Text.Scenario.reset, role: .destructive) {
                focusedField = nil
                settings = ScenarioSettings()
            }
            Button(AppConstants.Text.Scenario.cancel, role: .cancel) {}
        } message: {
            Text(AppConstants.Text.Scenario.resetConfirmationMessage)
        }
    }

    private var shiftSection: some View {
        SectionCard(AppConstants.Text.Scenario.settingsTitle, subtitle: AppConstants.Text.Scenario.settingsSubtitle) {
            Picker(AppConstants.Text.Common.scenario, selection: $settings.scenario) {
                ForEach(ScenarioKind.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .pickerStyle(.segmented)

            integerField(
                AppConstants.Text.Scenario.plan,
                value: $settings.orderShieldsQty,
                range: AppConstants.ScenarioLimits.planRange,
                unit: AppConstants.Text.Common.shieldsUnit,
                step: AppConstants.ScenarioLimits.planStep,
                field: .plan
            )
            decimalField(
                AppConstants.Text.Scenario.duration,
                value: $settings.shiftDurationHours,
                range: AppConstants.ScenarioLimits.durationRange,
                unit: AppConstants.Time.hourUnit,
                fractionDigits: 1,
                step: AppConstants.ScenarioLimits.durationStep,
                field: .duration
            )
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
            integerField(AppConstants.Text.Scenario.sourceTubes, value: $settings.sourceTubes, range: AppConstants.ScenarioLimits.sourceTubesRange, unit: AppConstants.Text.Common.piecesUnit, field: .sourceTubes)
            integerField(AppConstants.Text.Scenario.tubesAtC1, value: $settings.initialTubesAtC1, range: AppConstants.ScenarioLimits.c1TubesRange, unit: AppConstants.Text.Common.piecesUnit, field: .tubesAtC1)
            integerField(AppConstants.Text.Scenario.shieldsAtC2, value: $settings.initialC2, range: AppConstants.ScenarioLimits.inventoryRange, unit: AppConstants.Text.Common.piecesUnit, field: .shieldsAtC2)
            integerField(AppConstants.Text.Scenario.shieldsAtC3, value: $settings.initialC3, range: AppConstants.ScenarioLimits.inventoryRange, unit: AppConstants.Text.Common.piecesUnit, field: .shieldsAtC3)
            integerField(AppConstants.Text.Scenario.finishedAtC4, value: $settings.initialC4, range: AppConstants.ScenarioLimits.inventoryRange, unit: AppConstants.Text.Common.piecesUnit, field: .finishedAtC4)
        }
    }

    private var handlingSection: some View {
        SectionCard(AppConstants.Text.Scenario.handlingTitle, subtitle: AppConstants.Text.Scenario.handlingSubtitle) {
            decimalField(AppConstants.Text.Scenario.tubeLoad, value: $settings.tubeLoadMin, range: AppConstants.ScenarioLimits.handlingRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.handlingStep, field: .tubeLoad)
            decimalField(AppConstants.Text.Scenario.tubeUnload, value: $settings.tubeUnloadMin, range: AppConstants.ScenarioLimits.handlingRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.handlingStep, field: .tubeUnload)
            decimalField(AppConstants.Text.Scenario.shieldLoad, value: $settings.shieldLoadMin, range: AppConstants.ScenarioLimits.handlingRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.handlingStep, field: .shieldLoad)
            decimalField(AppConstants.Text.Scenario.shieldUnload, value: $settings.shieldUnloadMin, range: AppConstants.ScenarioLimits.handlingRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.handlingStep, field: .shieldUnload)
            decimalField(AppConstants.Text.Scenario.finishedLoad, value: $settings.finishedLoadMin, range: AppConstants.ScenarioLimits.handlingRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.handlingStep, field: .finishedLoad)
            decimalField(AppConstants.Text.Scenario.finishedUnload, value: $settings.finishedUnloadMin, range: AppConstants.ScenarioLimits.handlingRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.handlingStep, field: .finishedUnload)
        }
    }

    private var travelSection: some View {
        SectionCard(AppConstants.Text.Scenario.travelTitle, subtitle: AppConstants.Text.Scenario.travelSubtitle) {
            decimalField(AppConstants.Route.sC1, value: $settings.travelSC1, range: AppConstants.ScenarioLimits.travelRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.travelStep, field: .travelSC1)
            decimalField(AppConstants.Route.c1C2, value: $settings.travelC1C2, range: AppConstants.ScenarioLimits.travelRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.travelStep, field: .travelC1C2)
            decimalField(AppConstants.Route.c2C3, value: $settings.travelC2C3, range: AppConstants.ScenarioLimits.travelRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.travelStep, field: .travelC2C3)
            decimalField(AppConstants.Route.c3C4, value: $settings.travelC3C4, range: AppConstants.ScenarioLimits.travelRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.travelStep, field: .travelC3C4)
            decimalField(AppConstants.Route.c4P, value: $settings.travelC4P, range: AppConstants.ScenarioLimits.travelRange, unit: AppConstants.Time.minuteUnit, fractionDigits: 1, step: AppConstants.ScenarioLimits.travelStep, field: .travelC4P)
        }
    }

    private var productionSection: some View {
        SectionCard(AppConstants.Text.Scenario.productionTitle, subtitle: AppConstants.Text.Scenario.productionSubtitle) {
            decimalField(AppConstants.Text.Scenario.c1, value: $settings.c1RatePerHour, range: AppConstants.ScenarioLimits.productionRateRange, unit: AppConstants.Text.Scenario.shieldsPerHour, fractionDigits: 1, step: AppConstants.ScenarioLimits.c3RateStep, field: .productionC1)
            decimalField(AppConstants.Text.Scenario.c2, value: $settings.c2RatePerHour, range: AppConstants.ScenarioLimits.productionRateRange, unit: AppConstants.Text.Scenario.shieldsPerHour, fractionDigits: 1, step: AppConstants.ScenarioLimits.c3RateStep, field: .productionC2)
            decimalField(AppConstants.Text.Scenario.c3, value: $settings.c3RatePerHour, range: AppConstants.ScenarioLimits.c3RateRange, unit: AppConstants.Text.Scenario.shieldsPerHour, fractionDigits: 1, step: AppConstants.ScenarioLimits.c3RateStep, field: .productionC3)
            decimalField(AppConstants.Text.Scenario.c4, value: $settings.c4RatePerHour, range: AppConstants.ScenarioLimits.productionRateRange, unit: AppConstants.Text.Scenario.shieldsPerHour, fractionDigits: 1, step: AppConstants.ScenarioLimits.c3RateStep, field: .productionC4)
        }
    }

    private var objectiveSection: some View {
        SectionCard(AppConstants.Text.Scenario.objectiveTitle, subtitle: AppConstants.Text.Scenario.objectiveSubtitle) {
            decimalField(AppConstants.Text.Scenario.underproductionPenalty, value: $settings.underproductionPenalty, range: AppConstants.ScenarioLimits.underproductionPenaltyRange, fractionDigits: 0, step: AppConstants.ScenarioLimits.underproductionPenaltyStep, field: .underproductionPenalty)
            decimalField(AppConstants.Text.Scenario.makespanWeight, value: $settings.makespanWeight, range: AppConstants.ScenarioLimits.makespanWeightRange, fractionDigits: 1, step: AppConstants.ScenarioLimits.makespanWeightStep, field: .makespanWeight)
            decimalField(AppConstants.Text.Scenario.c3StarvationWeight, value: $settings.c3StarvationWeight, range: AppConstants.ScenarioLimits.c3StarvationWeightRange, fractionDigits: 1, step: AppConstants.ScenarioLimits.c3StarvationWeightStep, field: .c3StarvationWeight)
            decimalField(AppConstants.Text.Scenario.forkliftIdleWeight, value: $settings.forkliftIdleWeight, range: AppConstants.ScenarioLimits.forkliftIdleWeightRange, fractionDigits: 1, step: AppConstants.ScenarioLimits.forkliftIdleWeightStep, field: .forkliftIdleWeight)
        }
    }

    private var annealingSection: some View {
        SectionCard(AppConstants.Text.Scenario.annealingTitle, subtitle: AppConstants.Text.Scenario.annealingSubtitle) {
            integerField(
                AppConstants.Text.Scenario.iterations,
                value: $settings.iterations,
                range: AppConstants.ScenarioLimits.iterationsRange,
                step: AppConstants.ScenarioLimits.iterationsStep,
                field: .iterations
            )
            decimalField(AppConstants.Text.Scenario.initialTemperature, value: $settings.initialTemperature, range: AppConstants.ScenarioLimits.initialTemperatureRange, fractionDigits: 0, step: AppConstants.ScenarioLimits.initialTemperatureStep, field: .initialTemperature)
            decimalField(AppConstants.Text.Scenario.coolingRate, value: $settings.coolingRate, range: AppConstants.ScenarioLimits.coolingRateRange, fractionDigits: 3, step: AppConstants.ScenarioLimits.coolingRateStep, field: .coolingRate)
            decimalField(AppConstants.Text.Scenario.minTemperature, value: $settings.minTemperature, range: AppConstants.ScenarioLimits.minTemperatureRange, fractionDigits: 3, step: AppConstants.ScenarioLimits.minTemperatureStep, field: .minTemperature)
            integerField(AppConstants.Text.Scenario.seed, value: $settings.seed, range: AppConstants.ScenarioLimits.seedRange, field: .seed)
        }
    }

    private func integerField(
        _ title: String,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        unit: String? = nil,
        step: Int = 1,
        field: ScenarioField
    ) -> some View {
        NumericParameterRow(
            title: title,
            value: Binding(
                get: { Double(value.wrappedValue) },
                set: { value.wrappedValue = Int($0.rounded()) }
            ),
            range: Double(range.lowerBound)...Double(range.upperBound),
            unit: unit,
            fractionDigits: 0,
            step: Double(step),
            field: field,
            focusedField: $focusedField
        )
    }

    private func decimalField(
        _ title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        unit: String? = nil,
        fractionDigits: Int,
        step: Double,
        field: ScenarioField
    ) -> some View {
        NumericParameterRow(
            title: title,
            value: value,
            range: range,
            unit: unit,
            fractionDigits: fractionDigits,
            step: step,
            field: field,
            focusedField: $focusedField
        )
    }

    private func moveFocus(by offset: Int) {
        guard
            let focusedField,
            let index = ScenarioField.allCases.firstIndex(of: focusedField)
        else { return }

        let nextIndex = index + offset
        guard ScenarioField.allCases.indices.contains(nextIndex) else { return }
        self.focusedField = ScenarioField.allCases[nextIndex]
    }
}

private enum ScenarioField: Int, CaseIterable, Hashable {
    case plan, duration
    case sourceTubes, tubesAtC1, shieldsAtC2, shieldsAtC3, finishedAtC4
    case tubeLoad, tubeUnload, shieldLoad, shieldUnload, finishedLoad, finishedUnload
    case travelSC1, travelC1C2, travelC2C3, travelC3C4, travelC4P
    case productionC1, productionC2, productionC3, productionC4
    case underproductionPenalty, makespanWeight, c3StarvationWeight, forkliftIdleWeight
    case iterations, initialTemperature, coolingRate, minTemperature, seed
}

private struct NumericParameterRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String?
    let fractionDigits: Int
    let step: Double
    let field: ScenarioField
    let focusedField: FocusState<ScenarioField?>.Binding

    @State private var text: String

    init(
        title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        unit: String?,
        fractionDigits: Int,
        step: Double,
        field: ScenarioField,
        focusedField: FocusState<ScenarioField?>.Binding
    ) {
        self.title = title
        _value = value
        self.range = range
        self.unit = unit
        self.fractionDigits = fractionDigits
        self.step = step
        self.field = field
        self.focusedField = focusedField
        _text = State(initialValue: Self.format(value.wrappedValue, fractionDigits: fractionDigits))
    }

    private var parsedValue: Double? {
        let normalized = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }

    private var validationMessage: String? {
        guard parsedValue != nil else {
            return AppConstants.Text.Scenario.enterNumber
        }
        guard let parsedValue, range.contains(parsedValue) else {
            let lower = Self.format(range.lowerBound, fractionDigits: fractionDigits)
            let upper = Self.format(range.upperBound, fractionDigits: fractionDigits)
            return "\(AppConstants.Text.Scenario.allowedRange) \(lower)–\(upper)"
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.tinySpacing) {
            HStack(alignment: .center, spacing: AppConstants.Layout.compactSpacing) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: AppConstants.Layout.numericInputRowHeight,
                        alignment: .leading
                    )
                    .layoutPriority(1)

                controls
            }

            if let validationMessage {
                Text(validationMessage)
                    .font(.caption2)
                    .foregroundStyle(AppColors.warning)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .onChange(of: text) { _, newValue in
            commitIfValid(newValue)
        }
        .onChange(of: value) { _, newValue in
            guard focusedField.wrappedValue != field else { return }
            text = Self.format(newValue, fractionDigits: fractionDigits)
        }
    }

    private var controls: some View {
        HStack(spacing: AppConstants.Layout.tinySpacing) {
            stepButton(systemImage: "minus", delta: -step)

            valueField

            stepButton(systemImage: "plus", delta: step)
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private var valueField: some View {
        HStack(spacing: AppConstants.Layout.tinySpacing) {
            TextField(AppConstants.Text.Scenario.numberPlaceholder, text: $text)
                .keyboardType(fractionDigits == 0 ? .numberPad : .decimalPad)
                .multilineTextAlignment(.trailing)
                .font(.body.monospacedDigit().weight(.semibold))
                .foregroundStyle(AppColors.ink)
                .focused(focusedField, equals: field)
                .accessibilityLabel(title)

            if let unit {
                Text(unit)
                    .font(.caption2)
                    .foregroundStyle(AppColors.muted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .padding(.horizontal, AppConstants.Layout.compactSpacing)
        .frame(
            width: AppConstants.Layout.numericFieldWidth,
            height: AppConstants.Layout.numericInputRowHeight
        )
        .background(AppColors.background)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.compactSpacing, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AppConstants.Layout.compactSpacing, style: .continuous)
                .stroke(
                    validationMessage == nil ? AppColors.accent.opacity(0.25) : AppColors.warning,
                    lineWidth: validationMessage == nil ? 1 : 1.5
                )
        }
    }

    private func stepButton(systemImage: String, delta: Double) -> some View {
        Button {
            adjust(by: delta)
        } label: {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .frame(
                    width: AppConstants.Layout.numericControlButtonWidth,
                    height: AppConstants.Layout.numericInputRowHeight
                )
                .background(AppColors.accent.opacity(AppConstants.Opacity.accentBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.compactSpacing, style: .continuous))
        }
        .buttonStyle(.plain)
        .foregroundStyle(AppColors.accent)
        .buttonRepeatBehavior(.enabled)
        .disabled(delta < 0 ? value <= range.lowerBound : value >= range.upperBound)
        .accessibilityLabel(delta < 0 ? "Уменьшить \(title)" : "Увеличить \(title)")
    }

    private func commitIfValid(_ candidate: String) {
        let normalized = candidate
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let number = Double(normalized), range.contains(number) else { return }
        value = number
    }

    private func adjust(by delta: Double) {
        let base = parsedValue.flatMap { range.contains($0) ? $0 : nil } ?? value
        let adjusted = min(max(base + delta, range.lowerBound), range.upperBound)
        value = adjusted
        text = Self.format(adjusted, fractionDigits: fractionDigits)
    }

    private static func format(_ value: Double, fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}

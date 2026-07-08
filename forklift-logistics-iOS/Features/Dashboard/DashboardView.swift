import SwiftUI

struct DashboardView: View {
    @Bindable var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppConstants.Layout.screenSpacing) {
                    header
                    controls

                    if let errorMessage = viewModel.errorMessage {
                        InfoTipView(title: AppConstants.Text.Dashboard.errorTitle, message: errorMessage, isCollapsible: false)
                    }

                    if let result = viewModel.result {
                        summary(result)
                        comparisonTable(result)
                    } else {
                        emptyState
                    }
                }
                .padding()
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle(AppConstants.Text.Dashboard.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(AppConstants.Text.Common.scenario) {
                    ScenarioSetupView(settings: $viewModel.settings)
                }
            }
        }
    }

    private var header: some View {
        SectionCard(AppConstants.Text.Dashboard.cardTitle, subtitle: AppConstants.Text.Dashboard.cardSubtitle) {
            VStack(spacing: AppConstants.Layout.compactSpacing) {
                InfoTipView(title: AppConstants.Text.Dashboard.resultTipTitle, message: AppConstants.Text.Dashboard.resultTipMessage)
                InfoTipView(title: AppConstants.Text.Dashboard.scenarioTipTitle, message: AppConstants.Text.Dashboard.scenarioTipMessage)
            }
        }
    }

    private var controls: some View {
        SectionCard(AppConstants.Text.Dashboard.launchTitle, subtitle: "\(viewModel.settings.scenario.title), \(AppConstants.Text.Dashboard.planPrefix.lowercased()) \(viewModel.settings.orderShieldsQty) \(AppConstants.Text.Common.shieldsUnit)") {
            Button {
                Task { await viewModel.runCalculation() }
            } label: {
                HStack {
                    if viewModel.isLoading { ProgressView() }
                    Text(viewModel.isLoading ? AppConstants.Text.Dashboard.loadingButton : AppConstants.Text.Dashboard.runButton)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius, style: .continuous))
            }
            .disabled(viewModel.isLoading)
        }
    }

    private func summary(_ result: CompareResult) -> some View {
        SectionCard(AppConstants.Text.Dashboard.summaryTitle, subtitle: "\(AppConstants.Text.Dashboard.planPrefix): \(result.scenario.orderShieldsQty) \(AppConstants.Text.Common.shieldsUnit)") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppConstants.Layout.mediumSpacing) {
                MetricCard(title: AppConstants.Text.Common.greedyShort, value: NumberFormatting.two(result.greedy.metrics.shippedQty), subtitle: AppConstants.Text.Dashboard.shippedSubtitle, tone: .neutral)
                MetricCard(title: AppConstants.Text.Common.annealingShort, value: NumberFormatting.two(result.annealing.metrics.shippedQty), subtitle: deltaText(result.delta.shippedQty, unit: AppConstants.Text.Common.shieldsUnit), tone: result.delta.shippedQty >= 0 ? .success : .warning)
                MetricCard(title: AppConstants.Text.Dashboard.c3Idle, value: TimeFormatting.compactMinutes(result.annealing.metrics.c3StarvationMin), subtitle: deltaText(result.delta.c3StarvationMin, unit: AppConstants.Time.minuteUnit), tone: .warning)
                MetricCard(title: AppConstants.Text.Dashboard.objective, value: NumberFormatting.two(result.annealing.metrics.objectiveValue), subtitle: AppConstants.Text.Dashboard.lowerIsBetter, tone: .accent)
            }
        }
    }

    private func comparisonTable(_ result: CompareResult) -> some View {
        SectionCard(AppConstants.Text.Dashboard.comparisonTableTitle, subtitle: AppConstants.Text.Dashboard.comparisonTableSubtitle) {
            VStack(spacing: .zero) {
                ComparisonHeader()
                ForEach(comparisonRows(result)) { row in
                    ComparisonMetricRow(row: row)
                }
            }
            .background(AppColors.background.opacity(0.65))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.metricCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.metricCornerRadius, style: .continuous)
                    .stroke(AppColors.accent.opacity(0.10), lineWidth: 1)
            )
        }
    }

    private func comparisonRows(_ result: CompareResult) -> [ComparisonRow] {
        [
            ComparisonRow(title: AppConstants.Text.Dashboard.shipped, greedy: NumberFormatting.two(result.greedy.metrics.shippedQty), annealing: NumberFormatting.two(result.annealing.metrics.shippedQty), highlightAnnealing: result.annealing.metrics.shippedQty >= result.greedy.metrics.shippedQty),
            ComparisonRow(title: AppConstants.Text.Dashboard.shortfall, greedy: NumberFormatting.two(result.greedy.metrics.shortfallQty), annealing: NumberFormatting.two(result.annealing.metrics.shortfallQty), highlightAnnealing: result.annealing.metrics.shortfallQty <= result.greedy.metrics.shortfallQty),
            ComparisonRow(title: AppConstants.Text.Dashboard.objective, greedy: NumberFormatting.two(result.greedy.metrics.objectiveValue), annealing: NumberFormatting.two(result.annealing.metrics.objectiveValue), highlightAnnealing: result.annealing.metrics.objectiveValue <= result.greedy.metrics.objectiveValue),
            ComparisonRow(title: AppConstants.Text.Dashboard.makespan, greedy: result.greedy.metrics.makespanHMS, annealing: result.annealing.metrics.makespanHMS, highlightAnnealing: result.annealing.metrics.makespanMin <= result.greedy.metrics.makespanMin),
            ComparisonRow(title: AppConstants.Text.Dashboard.c3Idle, greedy: result.greedy.metrics.c3StarvationHMS, annealing: result.annealing.metrics.c3StarvationHMS, highlightAnnealing: result.annealing.metrics.c3StarvationMin <= result.greedy.metrics.c3StarvationMin),
            ComparisonRow(title: AppConstants.Text.Dashboard.tripCount, greedy: "\(result.greedy.metrics.tripsTotal)", annealing: "\(result.annealing.metrics.tripsTotal)", highlightAnnealing: false),
            ComparisonRow(title: AppConstants.Text.Dashboard.avgLoadUnits, greedy: NumberFormatting.two(result.greedy.metrics.avgTripLoadUnits), annealing: NumberFormatting.two(result.annealing.metrics.avgTripLoadUnits), highlightAnnealing: result.annealing.metrics.avgTripLoadUnits >= result.greedy.metrics.avgTripLoadUnits),
            ComparisonRow(title: AppConstants.Text.Dashboard.avgLoadFactor, greedy: NumberFormatting.percent(result.greedy.metrics.avgTripLoadFactor), annealing: NumberFormatting.percent(result.annealing.metrics.avgTripLoadFactor), highlightAnnealing: result.annealing.metrics.avgTripLoadFactor >= result.greedy.metrics.avgTripLoadFactor),
            ComparisonRow(title: AppConstants.Text.Dashboard.forkliftUtilization, greedy: NumberFormatting.percent(result.greedy.metrics.avgForkliftUtilization), annealing: NumberFormatting.percent(result.annealing.metrics.avgForkliftUtilization), highlightAnnealing: result.annealing.metrics.avgForkliftUtilization >= result.greedy.metrics.avgForkliftUtilization),
            ComparisonRow(title: AppConstants.Text.Dashboard.emptyTravel, greedy: TimeFormatting.compactMinutes(result.greedy.metrics.emptyTravelTotalMin), annealing: TimeFormatting.compactMinutes(result.annealing.metrics.emptyTravelTotalMin), highlightAnnealing: result.annealing.metrics.emptyTravelTotalMin <= result.greedy.metrics.emptyTravelTotalMin)
        ]
    }

    private var emptyState: some View {
        SectionCard(AppConstants.Text.Dashboard.emptyTitle) {
            Text(AppConstants.Text.Dashboard.emptyMessage)
                .foregroundStyle(AppColors.muted)
        }
    }

    private func deltaText(_ value: Double, unit: String) -> String {
        "\(NumberFormatting.signedTwo(value)) \(unit)"
    }
}

private struct ComparisonRow: Identifiable {
    var id: String { title }
    let title: String
    let greedy: String
    let annealing: String
    let highlightAnnealing: Bool
}

private struct ComparisonHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
            Text(AppConstants.Text.Dashboard.metricName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.muted)
            HStack(spacing: AppConstants.Layout.compactSpacing) {
                Text(AppConstants.Text.Common.greedyFull)
                    .frame(maxWidth: .infinity)
                Text(AppConstants.Text.Common.annealingFull)
                    .frame(maxWidth: .infinity)
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(AppColors.accent)
        }
        .padding(AppConstants.Layout.mediumSpacing)
        .background(AppColors.accent.opacity(AppConstants.Opacity.accentBackground))
    }
}

private struct ComparisonMetricRow: View {
    let row: ComparisonRow

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
            Text(row.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.muted)
            HStack(spacing: AppConstants.Layout.compactSpacing) {
                valueCell(row.greedy, isHighlighted: !row.highlightAnnealing)
                valueCell(row.annealing, isHighlighted: row.highlightAnnealing)
            }
        }
        .padding(AppConstants.Layout.mediumSpacing)
        .background(AppColors.card)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AppColors.background)
                .frame(height: 1)
        }
    }

    private func valueCell(_ value: String, isHighlighted: Bool) -> some View {
        Text(value)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isHighlighted ? AppColors.success : AppColors.ink)
            .frame(maxWidth: .infinity, minHeight: 34)
            .background((isHighlighted ? AppColors.success : AppColors.background).opacity(isHighlighted ? 0.10 : 0.72))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.compactSpacing, style: .continuous))
    }
}

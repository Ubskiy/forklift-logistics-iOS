import SwiftUI

struct TimelineView: View {
    let result: CompareResult
    @Binding var selectedStrategy: StrategySelector
    @State private var selectedTrip: TripRecord?

    private var strategy: StrategyResult {
        selectedStrategy == .greedy ? result.greedy : result.annealing
    }

    var body: some View {
        VStack(spacing: .zero) {
            StickyControlsBar {
                StrategySelectorCard(selectedStrategy: $selectedStrategy)
            }

            ScrollView {
                VStack(spacing: AppConstants.Layout.screenSpacing) {
                    SectionCard(AppConstants.Text.Timeline.cardTitle, subtitle: strategy.title) {
                        InfoTipView(title: AppConstants.Text.Timeline.tipTitle, message: AppConstants.Text.Timeline.tipMessage)
                        TimelineChart(trips: strategy.tripLog, shiftDurationMin: result.scenario.shiftDurationHours * AppConstants.Time.minutesInHour, selectedTrip: $selectedTrip)
                        RouteLegendView()
                    }

                    if let selectedTrip {
                        TripDetailCard(trip: selectedTrip)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(AppConstants.Text.Common.timelineTitle)
        .onChange(of: selectedStrategy) { _, _ in selectedTrip = nil }
    }
}

private struct TimelineChart: View {
    let trips: [TripRecord]
    let shiftDurationMin: Double
    @Binding var selectedTrip: TripRecord?

    private var forklifts: [String] {
        Array(Set(trips.map(\.forkliftID))).sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.mediumSpacing) {
            GeometryReader { proxy in
                let labelWidth = AppConstants.Layout.timelineLabelWidth
                let chartWidth = max(proxy.size.width - labelWidth, 1)
                VStack(alignment: .leading, spacing: AppConstants.Layout.cardSpacing) {
                    ForEach(forklifts, id: \.self) { forklift in
                        HStack(spacing: AppConstants.Layout.compactSpacing) {
                            Text(ForkliftPresentation.shortTitle(for: forklift))
                                .font(.caption.weight(.semibold))
                                .frame(width: labelWidth - AppConstants.Layout.compactSpacing, alignment: .leading)
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: AppConstants.Layout.compactSpacing)
                                    .fill(AppColors.background)
                                    .frame(height: AppConstants.Layout.timelineRowHeight)
                                ForEach(trips.filter { $0.forkliftID == forklift }) { trip in
                                    let x = CGFloat(max(0, trip.startTimeMin) / max(shiftDurationMin, 1)) * chartWidth
                                    let width = max(CGFloat(trip.durationMinutes / max(shiftDurationMin, 1)) * chartWidth, AppConstants.Layout.timelineMinBarWidth)
                                    RoundedRectangle(cornerRadius: AppConstants.Layout.compactSpacing - 1)
                                        .fill(AppColors.route(trip.route))
                                        .frame(width: width, height: AppConstants.Layout.timelineTripHeight)
                                        .offset(x: x)
                                        .onTapGesture { selectedTrip = trip }
                                }
                            }
                            .frame(width: chartWidth, height: AppConstants.Layout.timelineRowHeight)
                        }
                    }
                }
            }
            .frame(height: CGFloat(max(forklifts.count, 1)) * AppConstants.Layout.timelineRowTotalHeight)

            HStack {
                Text(AppConstants.Text.Timeline.start)
                Spacer()
                Text("\(AppConstants.Text.Timeline.shift) \(TimeFormatting.compactMinutes(shiftDurationMin))")
            }
            .font(.caption)
            .foregroundStyle(AppColors.muted)
        }
    }
}

private struct RouteLegendView: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: AppConstants.Layout.legendMinWidth))], alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
            ForEach(AppConstants.Route.all, id: \.self) { route in
                HStack(spacing: AppConstants.Layout.compactSpacing - 2) {
                    Circle()
                        .fill(AppColors.route(route))
                        .frame(width: AppConstants.Layout.legendDotSize, height: AppConstants.Layout.legendDotSize)
                    Text(route)
                        .font(.caption)
                        .foregroundStyle(AppColors.muted)
                }
            }
        }
    }
}

private struct TripDetailCard: View {
    let trip: TripRecord

    var body: some View {
        SectionCard("\(AppConstants.Text.Timeline.tripPrefix)\(trip.tripID)", subtitle: trip.route) {
            VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
                Text("\(trip.interval) · \(ForkliftPresentation.title(for: trip.forkliftID)) · \(trip.cargoType)")
                    .font(.headline)
                Text("\(AppConstants.Text.Timeline.quantity): \(NumberFormatting.two(trip.qty)) \(AppConstants.Text.Common.piecesUnit), \(AppConstants.Text.Timeline.weight) \(NumberFormatting.two(trip.totalWeight)) \(AppConstants.Text.Common.kgUnit)")
                Text("\(AppConstants.Text.Timeline.loading): \(trip.loadInterval)")
                Text("\(AppConstants.Text.Timeline.travel): \(trip.travelInterval)")
                Text("\(AppConstants.Text.Timeline.unloading): \(trip.unloadInterval)")
            }
            .font(.subheadline)
            .foregroundStyle(AppColors.ink)
        }
    }
}

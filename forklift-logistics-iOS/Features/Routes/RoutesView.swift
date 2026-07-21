import SwiftUI

struct RoutesView: View {
    let result: CompareResult
    @Binding var selectedStrategy: StrategySelector

    private var strategy: StrategyResult {
        selectedStrategy == .greedy ? result.greedy : result.annealing
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppConstants.Layout.screenSpacing) {
                StrategySelectorCard(selectedStrategy: $selectedStrategy)

                InfoTipView(title: AppConstants.Text.Routes.tipTitle, message: AppConstants.Text.Routes.tipMessage)
                ForEach(strategy.routeStats) { route in
                    routeCard(route)
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .appScreen(title: AppConstants.Text.Common.routesTitle)
    }

    private func routeCard(_ route: RouteStat) -> some View {
        SectionCard(route.route, subtitle: strategy.title) {
            HStack(spacing: AppConstants.Layout.mediumSpacing) {
                MetricCard(title: AppConstants.Text.Routes.trips, value: "\(route.tripsCount)", tone: .accent)
                MetricCard(title: AppConstants.Text.Routes.avgBatch, value: NumberFormatting.two(route.avgTripSize), tone: .neutral)
            }
            HStack(spacing: AppConstants.Layout.mediumSpacing) {
                MetricCard(title: AppConstants.Text.Routes.shields, value: NumberFormatting.two(route.shieldsQty), tone: .success)
                MetricCard(title: AppConstants.Text.Routes.tubes, value: NumberFormatting.two(route.tubesQty), tone: .warning)
            }
            Text("\(AppConstants.Text.Routes.weight): \(NumberFormatting.two(route.totalWeightKg)) \(AppConstants.Text.Common.kgUnit) · \(AppConstants.Text.Routes.time): \(NumberFormatting.two(route.totalDurationMin)) \(AppConstants.Time.minuteUnit) · \(AppConstants.Text.Routes.tripsShare): \(NumberFormatting.two(route.tripsSharePct))\(AppConstants.NumberFormat.percent)")
                .font(.caption)
                .foregroundStyle(AppColors.muted)
        }
    }
}

import SwiftUI

struct RoutesView: View {
    let strategy: StrategyResult

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                InfoTipView(
                    title: "Что показывает статистика маршрутов",
                    message: "Здесь видно, какие плечи цепочки занимают больше рейсов и где перевозки идут мелкими партиями."
                )
                ForEach(strategy.routeStats) { route in
                    SectionCard(route.route) {
                        HStack(spacing: 12) {
                            MetricCard(title: "Рейсов", value: "\(route.tripsCount)", tone: .accent)
                            MetricCard(title: "Ср. партия", value: NumberFormatting.two(route.avgTripSize), tone: .neutral)
                        }
                        HStack(spacing: 12) {
                            MetricCard(title: "Щитов", value: NumberFormatting.two(route.shieldsQty), tone: .success)
                            MetricCard(title: "Труб", value: NumberFormatting.two(route.tubesQty), tone: .warning)
                        }
                        Text("Вес: \(NumberFormatting.two(route.totalWeightKg)) кг · время: \(NumberFormatting.two(route.totalDurationMin)) мин · доля рейсов: \(NumberFormatting.two(route.tripsSharePct))%")
                            .font(.caption)
                            .foregroundStyle(AppColors.muted)
                    }
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Маршруты")
    }
}

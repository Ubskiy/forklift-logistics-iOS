import SwiftUI

struct TimelineView: View {
    let strategy: StrategyResult
    let shiftDurationHours: Double
    @State private var selectedTrip: TripRecord?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionCard("Таймлайн погрузчиков", subtitle: strategy.title) {
                    InfoTipView(
                        title: "Как читать график",
                        message: "Каждая строка — отдельный погрузчик. Цвет блока показывает маршрут. Чем шире блок, тем дольше рейс с учётом порожнего перегона, погрузки, движения и выгрузки."
                    )
                    TimelineChart(
                        trips: strategy.tripLog,
                        shiftDurationMin: shiftDurationHours * 60,
                        selectedTrip: $selectedTrip
                    )
                    RouteLegendView()
                }

                if let selectedTrip {
                    TripDetailCard(trip: selectedTrip)
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Таймлайн")
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
        VStack(alignment: .leading, spacing: 12) {
            GeometryReader { proxy in
                let labelWidth: CGFloat = 48
                let chartWidth = max(proxy.size.width - labelWidth, 1)
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(forklifts, id: \.self) { forklift in
                        HStack(spacing: 8) {
                            Text(ForkliftPresentation.shortTitle(for: forklift))
                                .font(.caption.weight(.semibold))
                                .frame(width: labelWidth - 8, alignment: .leading)
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.background)
                                    .frame(height: 36)
                                ForEach(trips.filter { $0.forkliftID == forklift }) { trip in
                                    let x = CGFloat(max(0, trip.startTimeMin) / max(shiftDurationMin, 1)) * chartWidth
                                    let width = max(CGFloat(trip.durationMinutes / max(shiftDurationMin, 1)) * chartWidth, 3)
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(AppColors.route(trip.route))
                                        .frame(width: width, height: 28)
                                        .offset(x: x)
                                        .onTapGesture { selectedTrip = trip }
                                }
                            }
                            .frame(width: chartWidth, height: 36)
                        }
                    }
                }
            }
            .frame(height: CGFloat(max(forklifts.count, 1)) * 50)

            HStack {
                Text("Старт")
                Spacer()
                Text("Смена \(TimeFormatting.compactMinutes(shiftDurationMin))")
            }
            .font(.caption)
            .foregroundStyle(AppColors.muted)
        }
    }
}

private struct RouteLegendView: View {
    private let routes = ["S->C1", "C1->C2", "C2->C3", "C3->C4", "C4->P"]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 92))], alignment: .leading, spacing: 8) {
            ForEach(routes, id: \.self) { route in
                HStack(spacing: 6) {
                    Circle()
                        .fill(AppColors.route(route))
                        .frame(width: 10, height: 10)
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
        SectionCard("Рейс №\(trip.tripID)", subtitle: trip.route) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(trip.interval) · \(ForkliftPresentation.title(for: trip.forkliftID)) · \(trip.cargoType)")
                    .font(.headline)
                Text("Количество: \(NumberFormatting.two(trip.qty)) шт, вес: \(NumberFormatting.two(trip.totalWeight)) кг")
                Text("Погрузка: \(trip.loadInterval)")
                Text("Движение: \(trip.travelInterval)")
                Text("Выгрузка: \(trip.unloadInterval)")
            }
            .font(.subheadline)
            .foregroundStyle(AppColors.ink)
        }
    }
}

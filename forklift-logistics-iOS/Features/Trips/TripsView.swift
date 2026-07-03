import SwiftUI

struct TripsView: View {
    let strategy: StrategyResult
    @State private var selectedForklift = "Все"

    private var forkliftIDs: [String] {
        Array(Set(strategy.tripLog.map(\.forkliftID))).sorted()
    }

    private var filterTitles: [String] {
        ["Все"] + forkliftIDs.map { ForkliftPresentation.title(for: $0) }
    }

    private var filteredTrips: [TripRecord] {
        guard selectedForklift != "Все" else { return strategy.tripLog }
        return strategy.tripLog.filter { ForkliftPresentation.title(for: $0.forkliftID) == selectedForklift }
    }

    var body: some View {
        List {
            Section {
                Picker("Погрузчик", selection: $selectedForklift) {
                    ForEach(filterTitles, id: \.self) { title in
                        Text(title).tag(title)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Рейсы") {
                ForEach(filteredTrips) { trip in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(trip.interval)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(ForkliftPresentation.title(for: trip.forkliftID))
                                .font(.caption.weight(.bold))
                                .foregroundStyle(ForkliftPresentation.color(for: trip.forkliftID))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ForkliftPresentation.color(for: trip.forkliftID).opacity(0.14))
                                .clipShape(Capsule())
                        }
                        Text("\(trip.route) · \(trip.cargoType) · \(NumberFormatting.two(trip.qty)) шт")
                            .foregroundStyle(AppColors.ink)
                        Text("Вес: \(NumberFormatting.two(trip.totalWeight)) кг")
                            .font(.caption)
                            .foregroundStyle(AppColors.muted)
                        Text("Погрузка \(trip.loadInterval), движение \(trip.travelInterval), выгрузка \(trip.unloadInterval)")
                            .font(.caption)
                            .foregroundStyle(AppColors.muted)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Журнал рейсов")
    }
}

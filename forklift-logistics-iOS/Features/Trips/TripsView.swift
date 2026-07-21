import SwiftUI

struct TripsView: View {
    let result: CompareResult
    @Binding var selectedStrategy: StrategySelector
    @State private var selectedForklift = AppConstants.Forklift.allFilterTitle

    private var strategy: StrategyResult {
        selectedStrategy == .greedy ? result.greedy : result.annealing
    }

    private var forkliftIDs: [String] {
        Array(Set(strategy.tripLog.map(\.forkliftID))).sorted()
    }

    private var filterTitles: [String] {
        [AppConstants.Forklift.allFilterTitle] + forkliftIDs.map { ForkliftPresentation.title(for: $0) }
    }

    private var filteredTrips: [TripRecord] {
        guard selectedForklift != AppConstants.Forklift.allFilterTitle else { return strategy.tripLog }
        return strategy.tripLog.filter { ForkliftPresentation.title(for: $0.forkliftID) == selectedForklift }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .zero, pinnedViews: [.sectionHeaders]) {
                Section {
                    SectionCard("\(AppConstants.Text.Trips.section): \(strategy.title)") {
                        ForEach(filteredTrips) { trip in
                            tripRow(trip)
                            if trip.id != filteredTrips.last?.id {
                                Divider()
                                    .overlay(AppColors.background)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, AppConstants.Layout.screenSpacing)
                    .padding(.bottom)
                } header: {
                    TripsStickyFilters(
                        selectedStrategy: $selectedStrategy,
                        selectedForklift: $selectedForklift,
                        filterTitles: filterTitles
                    )
                }
            }
        }
        .background(AppColors.background.ignoresSafeArea())
        .appScreen(title: AppConstants.Text.Common.tripsTitle)
        .onChange(of: selectedStrategy) { _, _ in keepAvailableForkliftSelection() }
        .onChange(of: forkliftIDs) { _, _ in keepAvailableForkliftSelection() }
    }

    private func keepAvailableForkliftSelection() {
        guard selectedForklift != AppConstants.Forklift.allFilterTitle else { return }
        if !filterTitles.contains(selectedForklift) {
            selectedForklift = AppConstants.Forklift.allFilterTitle
        }
    }

    private func tripRow(_ trip: TripRecord) -> some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
            HStack {
                Text(trip.interval)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(ForkliftPresentation.title(for: trip.forkliftID))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(ForkliftPresentation.color(for: trip.forkliftID))
                    .padding(.horizontal, AppConstants.Layout.forkliftBadgeHorizontalPadding)
                    .padding(.vertical, AppConstants.Layout.forkliftBadgeVerticalPadding)
                    .background(ForkliftPresentation.color(for: trip.forkliftID).opacity(AppConstants.Opacity.routeBackground))
                    .clipShape(Capsule())
            }
            Text("\(trip.route) · \(trip.cargoType) · \(NumberFormatting.two(trip.qty)) \(AppConstants.Text.Common.piecesUnit)")
                .foregroundStyle(AppColors.ink)
            Text("\(AppConstants.Text.Trips.weight): \(NumberFormatting.two(trip.totalWeight)) \(AppConstants.Text.Common.kgUnit)")
                .font(.caption)
                .foregroundStyle(AppColors.muted)
            Text("\(AppConstants.Text.Trips.loading) \(trip.loadInterval), \(AppConstants.Text.Trips.travel) \(trip.travelInterval), \(AppConstants.Text.Trips.unloading) \(trip.unloadInterval)")
                .font(.caption)
                .foregroundStyle(AppColors.muted)
        }
        .padding(.vertical, AppConstants.Layout.tinySpacing)
    }
}

private struct TripsStickyFilters: View {
    @Binding var selectedStrategy: StrategySelector
    @Binding var selectedForklift: String
    let filterTitles: [String]

    var body: some View {
        HStack(spacing: AppConstants.Layout.compactSpacing) {
            FilterMenuChip(
                title: AppConstants.Text.Trips.strategyPicker,
                value: selectedStrategy.title
            ) {
                ForEach(StrategySelector.allCases) { strategy in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selectedStrategy = strategy
                        }
                    } label: {
                        if selectedStrategy == strategy {
                            Label(strategy.title, systemImage: "checkmark")
                        } else {
                            Text(strategy.title)
                        }
                    }
                }
            }

            FilterMenuChip(
                title: AppConstants.Text.Trips.picker,
                value: selectedForklift
            ) {
                ForEach(filterTitles, id: \.self) { title in
                    Button {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            selectedForklift = title
                        }
                    } label: {
                        if selectedForklift == title {
                            Label(title, systemImage: "checkmark")
                        } else {
                            Text(title)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, AppConstants.Layout.compactSpacing)
        .background(.ultraThinMaterial)
        .overlay(alignment: .bottom) {
            Divider()
                .overlay(AppColors.accent.opacity(0.12))
        }
        .shadow(color: .black.opacity(0.04), radius: 8, x: .zero, y: 4)
        .zIndex(1)
    }
}

private struct FilterMenuChip<MenuContent: View>: View {
    let title: String
    let value: String
    let menuContent: MenuContent

    init(
        title: String,
        value: String,
        @ViewBuilder menuContent: () -> MenuContent
    ) {
        self.title = title
        self.value = value
        self.menuContent = menuContent()
    }

    var body: some View {
        Menu {
            menuContent
        } label: {
            VStack(alignment: .leading, spacing: AppConstants.Layout.tinySpacing) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(AppColors.muted)

                HStack(spacing: AppConstants.Layout.tinySpacing) {
                    Text(value)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: .zero)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(AppColors.accent)
                }
            }
            .padding(.horizontal, AppConstants.Layout.mediumSpacing)
            .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
            .background(AppColors.card.opacity(0.94))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.tipCornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppConstants.Layout.tipCornerRadius, style: .continuous)
                    .stroke(AppColors.accent.opacity(0.18), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityLabel("\(title): \(value)")
    }
}

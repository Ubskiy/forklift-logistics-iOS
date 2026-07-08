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
        VStack(spacing: .zero) {
            StickyControlsBar {
                StickyControlsCard {
                    VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
                        StrategyPickerInline(selectedStrategy: $selectedStrategy)
                        ForkliftFilterToggle(selectedForklift: $selectedForklift, filterTitles: filterTitles)
                    }
                }
            }

            List {
                Section("\(AppConstants.Text.Trips.section): \(strategy.title)") {
                    ForEach(filteredTrips) { trip in
                        tripRow(trip)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(AppConstants.Text.Common.tripsTitle)
        .navigationBarTitleDisplayMode(.inline)
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

struct ForkliftFilterToggle: View {
    @Binding var selectedForklift: String
    let filterTitles: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.tinySpacing) {
            Text(AppConstants.Text.Trips.picker)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.muted)

            HStack(spacing: AppConstants.Layout.strategyTogglePadding) {
                ForEach(filterTitles, id: \.self) { title in
                    forkliftButton(title)
                }
            }
            .padding(AppConstants.Layout.strategyTogglePadding)
            .background(AppColors.accent.opacity(AppConstants.Opacity.accentBackground))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.forkliftToggleCornerRadius + AppConstants.Layout.strategyTogglePadding, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.forkliftToggleCornerRadius + AppConstants.Layout.strategyTogglePadding, style: .continuous)
                    .stroke(AppColors.accent.opacity(0.20), lineWidth: 1)
            )
        }
    }

    private func forkliftButton(_ title: String) -> some View {
        let isSelected = selectedForklift == title
        let color = color(for: title)

        return Button {
            withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
                selectedForklift = title
            }
        } label: {
            Text(title)
                .font(.caption2.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .foregroundStyle(isSelected ? .white : color)
                .frame(maxWidth: .infinity, minHeight: AppConstants.Layout.forkliftToggleHeight)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.forkliftToggleCornerRadius, style: .continuous)
                        .fill(isSelected ? color : AppColors.card)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.Layout.forkliftToggleCornerRadius, style: .continuous)
                        .stroke(color.opacity(isSelected ? 0 : 0.40), lineWidth: 1.1)
                )
                .shadow(
                    color: isSelected ? color.opacity(0.18) : .clear,
                    radius: isSelected ? 5 : 0,
                    x: .zero,
                    y: isSelected ? 2 : 0
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func color(for title: String) -> Color {
        guard title != AppConstants.Forklift.allFilterTitle else { return AppColors.accent }
        if title == ForkliftPresentation.title(for: AppConstants.Forklift.firstID) {
            return ForkliftPresentation.color(for: AppConstants.Forklift.firstID)
        }
        if title == ForkliftPresentation.title(for: AppConstants.Forklift.secondID) {
            return ForkliftPresentation.color(for: AppConstants.Forklift.secondID)
        }
        return AppColors.accent
    }
}

struct StrategyPickerInline: View {
    @Binding var selectedStrategy: StrategySelector

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.tinySpacing) {
            Text(AppConstants.Text.Dashboard.strategySelectorTitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.muted)
            StrategyToggle(selectedStrategy: $selectedStrategy)
        }
    }
}

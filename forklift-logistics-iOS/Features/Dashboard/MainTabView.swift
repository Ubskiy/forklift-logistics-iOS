import SwiftUI

struct MainTabView: View {
    @Bindable var viewModel: DashboardViewModel

    var body: some View {
        TabView {
            DashboardView(viewModel: viewModel)
                .tabItem { Label(AppConstants.Text.Common.calculationTitle, systemImage: AppConstants.SFIcon.dashboard) }

            NavigationStack {
                timelineContent
            }
            .tabItem { Label(AppConstants.Text.Common.timelineTitle, systemImage: AppConstants.SFIcon.timeline) }

            NavigationStack {
                tripsContent
            }
            .tabItem { Label(AppConstants.Text.Common.tripsTitle, systemImage: AppConstants.SFIcon.trips) }

            NavigationStack {
                routesContent
            }
            .tabItem { Label(AppConstants.Text.Common.routesTitle, systemImage: AppConstants.SFIcon.routes) }

            NavigationStack {
                HelpView()
            }
            .tabItem { Label(AppConstants.Text.Common.helpTitle, systemImage: AppConstants.SFIcon.help) }
        }
        .tint(AppColors.accent)
    }

    @ViewBuilder
    private var timelineContent: some View {
        if let result = viewModel.result {
            if result.greedy.tripLog.isEmpty || result.annealing.tripLog.isEmpty {
                LoadingDetailsView(title: AppConstants.Text.Common.timelineTitle, message: AppConstants.Text.Tabs.loadingTripsMessage, isLoading: viewModel.isLoadingTrips)
                    .task { await viewModel.loadTripsIfNeeded() }
            } else {
                TimelineView(result: result, selectedStrategy: $viewModel.selectedStrategy)
            }
        } else {
            NoResultView(title: AppConstants.Text.Common.timelineTitle, message: AppConstants.Text.Tabs.noTimelineMessage)
        }
    }

    @ViewBuilder
    private var tripsContent: some View {
        if let result = viewModel.result {
            if result.greedy.tripLog.isEmpty || result.annealing.tripLog.isEmpty {
                LoadingDetailsView(title: AppConstants.Text.Common.tripsTitle, message: AppConstants.Text.Tabs.loadingTripsMessage, isLoading: viewModel.isLoadingTrips)
                    .task { await viewModel.loadTripsIfNeeded() }
            } else {
                TripsView(result: result, selectedStrategy: $viewModel.selectedStrategy)
            }
        } else {
            NoResultView(title: AppConstants.Text.Common.tripsTitle, message: AppConstants.Text.Tabs.noTripsMessage)
        }
    }

    @ViewBuilder
    private var routesContent: some View {
        if let result = viewModel.result {
            if result.greedy.routeStats.isEmpty || result.annealing.routeStats.isEmpty {
                LoadingDetailsView(title: AppConstants.Text.Common.routesTitle, message: AppConstants.Text.Tabs.loadingRoutesMessage, isLoading: viewModel.isLoadingRoutes)
                    .task { await viewModel.loadRoutesIfNeeded() }
            } else {
                RoutesView(result: result, selectedStrategy: $viewModel.selectedStrategy)
            }
        } else {
            NoResultView(title: AppConstants.Text.Common.routesTitle, message: AppConstants.Text.Tabs.noRoutesMessage)
        }
    }
}

struct NoResultView: View {
    let title: String
    let message: String

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            SectionCard(title) {
                VStack(alignment: .leading, spacing: AppConstants.Layout.mediumSpacing) {
                    Image(systemName: AppConstants.SFIcon.tray)
                        .font(.largeTitle)
                        .foregroundStyle(AppColors.accent)
                    Text(message)
                        .foregroundStyle(AppColors.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

struct LoadingDetailsView: View {
    let title: String
    let message: String
    let isLoading: Bool

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            SectionCard(title) {
                VStack(alignment: .leading, spacing: AppConstants.Layout.mediumSpacing) {
                    if isLoading {
                        ProgressView()
                    }
                    Text(message)
                        .foregroundStyle(AppColors.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

struct StrategySelectorCard: View {
    @Binding var selectedStrategy: StrategySelector

    var body: some View {
        StickyControlsCard {
            VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
                Text(AppConstants.Text.Dashboard.strategySelectorTitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppColors.muted)
                StrategyToggle(selectedStrategy: $selectedStrategy)
            }
        }
    }
}

struct StickyControlsCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppConstants.Layout.stickyControlsPadding)
            .background(AppColors.card)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.metricCornerRadius, style: .continuous))
            .shadow(color: .black.opacity(AppConstants.Layout.shadowOpacity), radius: 8, x: .zero, y: 4)
    }
}

struct StickyControlsBar<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: AppConstants.Layout.compactSpacing) {
            content
        }
        .padding(.horizontal, AppConstants.Layout.screenSpacing)
        .padding(.top, AppConstants.Layout.compactSpacing)
        .padding(.bottom, AppConstants.Layout.compactSpacing)
        .background(AppColors.background)
    }
}

struct StrategyToggle: View {
    @Binding var selectedStrategy: StrategySelector

    var body: some View {
        HStack(spacing: AppConstants.Layout.strategyTogglePadding) {
            ForEach(StrategySelector.allCases) { strategy in
                Button {
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
                        selectedStrategy = strategy
                    }
                } label: {
                    Text(strategy.title)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(selectedStrategy == strategy ? .white : AppColors.accent)
                        .frame(maxWidth: .infinity, minHeight: AppConstants.Layout.strategyToggleHeight)
                        .background(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.strategyToggleCornerRadius, style: .continuous)
                                .fill(selectedStrategy == strategy ? AppColors.accent : AppColors.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppConstants.Layout.strategyToggleCornerRadius, style: .continuous)
                                .stroke(AppColors.accent.opacity(selectedStrategy == strategy ? 0 : 0.35), lineWidth: 1.1)
                        )
                        .shadow(
                            color: selectedStrategy == strategy ? AppColors.accent.opacity(0.18) : .clear,
                            radius: selectedStrategy == strategy ? 6 : 0,
                            x: .zero,
                            y: selectedStrategy == strategy ? 3 : 0
                        )
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedStrategy == strategy ? .isSelected : [])
            }
        }
        .padding(AppConstants.Layout.strategyTogglePadding)
        .background(AppColors.accent.opacity(AppConstants.Opacity.accentBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.strategyToggleCornerRadius + AppConstants.Layout.strategyTogglePadding, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Layout.strategyToggleCornerRadius + AppConstants.Layout.strategyTogglePadding, style: .continuous)
                .stroke(AppColors.accent.opacity(0.20), lineWidth: 1)
        )
    }
}

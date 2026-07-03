import SwiftUI

struct MainTabView: View {
    @Bindable var viewModel: DashboardViewModel

    var body: some View {
        TabView {
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Расчёт", systemImage: "speedometer")
                }

            NavigationStack {
                if let strategy = selectedStrategy {
                    TimelineView(strategy: strategy, shiftDurationHours: viewModel.result?.scenario.shiftDurationHours ?? 11)
                } else {
                    NoResultView(title: "Таймлайн", message: "Сначала запустите расчёт на главном экране.")
                }
            }
            .tabItem {
                Label("Таймлайн", systemImage: "chart.bar.xaxis")
            }

            NavigationStack {
                if let strategy = selectedStrategy {
                    TripsView(strategy: strategy)
                } else {
                    NoResultView(title: "Журнал рейсов", message: "После расчёта здесь появится последовательность рейсов по времени.")
                }
            }
            .tabItem {
                Label("Рейсы", systemImage: "list.bullet.rectangle")
            }

            NavigationStack {
                if let strategy = selectedStrategy {
                    RoutesView(strategy: strategy)
                } else {
                    NoResultView(title: "Маршруты", message: "После расчёта здесь появится статистика по маршрутам.")
                }
            }
            .tabItem {
                Label("Маршруты", systemImage: "arrow.triangle.branch")
            }

            NavigationStack {
                HelpView()
            }
            .tabItem {
                Label("Справка", systemImage: "questionmark.circle")
            }
        }
        .tint(AppColors.accent)
    }

    private var selectedStrategy: StrategyResult? {
        guard let result = viewModel.result else { return nil }
        return viewModel.selectedStrategy == .greedy ? result.greedy : result.annealing
    }
}

struct NoResultView: View {
    let title: String
    let message: String

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            SectionCard(title) {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "tray")
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

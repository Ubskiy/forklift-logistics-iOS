import SwiftUI

struct DashboardView: View {
    @Bindable var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    controls

                    if let errorMessage = viewModel.errorMessage {
                        InfoTipView(title: "Ошибка расчёта", message: errorMessage)
                    }

                    if let result = viewModel.result {
                        summary(result)
                        strategyPicker(result)
                        dashboardHint
                    } else {
                        emptyState
                    }
                }
                .padding()
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Логистика цеха")
            .toolbar {
                NavigationLink("Сценарий") {
                    ScenarioSetupView(settings: $viewModel.settings)
                }
            }
        }
    }

    private var header: some View {
        SectionCard("Диспетчерский расчёт", subtitle: "Сравнение жадной стратегии и имитации отжига") {
            VStack(spacing: 10) {
                InfoTipView(
                    title: "Как читать результат",
                    message: "Главная метрика — отгружено щитов. Если отгрузка одинаковая, сравнивайте простой C3, общее время и структуру рейсов."
                )
                InfoTipView(
                    title: "Где настроить сценарий",
                    message: "Параметры смены, план, остатки и итерации настраиваются справа сверху на кнопке «Сценарий»."
                )
            }
        }
    }

    private var controls: some View {
        SectionCard("Запуск", subtitle: "\(viewModel.settings.scenario.title), план \(viewModel.settings.orderShieldsQty) щитов") {
            Button {
                Task { await viewModel.runCalculation() }
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    Text(viewModel.isLoading ? "Идёт расчёт..." : "Запустить расчёт")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .disabled(viewModel.isLoading)
        }
    }

    private func summary(_ result: CompareResult) -> some View {
        SectionCard("Итог сравнения", subtitle: "План: \(result.scenario.orderShieldsQty) щитов") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricCard(title: "Жадная", value: NumberFormatting.two(result.greedy.metrics.shippedQty), subtitle: "отгружено", tone: .neutral)
                MetricCard(title: "Отжиг", value: NumberFormatting.two(result.annealing.metrics.shippedQty), subtitle: deltaText(result.delta.shippedQty, unit: "щитов"), tone: result.delta.shippedQty >= 0 ? .success : .warning)
                MetricCard(title: "Простой C3", value: TimeFormatting.compactMinutes(result.annealing.metrics.c3StarvationMin), subtitle: deltaText(result.delta.c3StarvationMin, unit: "мин"), tone: .warning)
                MetricCard(title: "Целевая функция", value: NumberFormatting.two(result.annealing.metrics.objectiveValue), subtitle: "меньше — лучше", tone: .accent)
            }
        }
    }

    private func strategyPicker(_ result: CompareResult) -> some View {
        SectionCard("Стратегия для детализации", subtitle: "Выбранная стратегия используется во вкладках снизу") {
            Picker("Стратегия", selection: $viewModel.selectedStrategy) {
                ForEach(StrategySelector.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .pickerStyle(.segmented)

            let strategy = selectedStrategy(from: result)
            VStack(alignment: .leading, spacing: 8) {
                Text(strategy.title)
                    .font(.headline)
                Text("Рейсов: \(strategy.metrics.tripsTotal), средняя партия: \(NumberFormatting.two(strategy.metrics.avgTripLoadUnits)), загрузка погрузчиков: \(NumberFormatting.percent(strategy.metrics.avgForkliftUtilization))")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.muted)
            }
        }
    }

    private func selectedStrategy(from result: CompareResult) -> StrategyResult {
        viewModel.selectedStrategy == .greedy ? result.greedy : result.annealing
    }

    private var dashboardHint: some View {
        SectionCard("Детализация") {
            Text("Используйте нижние вкладки: «Таймлайн», «Рейсы», «Маршруты» и «Справка». Они показывают выбранную выше стратегию.")
                .foregroundStyle(AppColors.muted)
        }
    }

    private var emptyState: some View {
        SectionCard("Пока нет расчёта") {
            Text("Настройте сценарий справа сверху на кнопке «Сценарий», затем нажмите «Запустить расчёт». После ответа backend появятся метрики, маршруты, журнал рейсов и нативный таймлайн.")
                .foregroundStyle(AppColors.muted)
        }
    }

    private func deltaText(_ value: Double, unit: String) -> String {
        "\(NumberFormatting.signedTwo(value)) \(unit)"
    }
}

import SwiftUI

struct ScenarioSetupView: View {
    @Binding var settings: ScenarioSettings

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionCard("Параметры смены", subtitle: "Базовые настройки расчёта") {
                    Picker("Сценарий", selection: $settings.scenario) {
                        ForEach(ScenarioKind.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)

                    Stepper("План отгрузки: \(settings.orderShieldsQty) щитов", value: $settings.orderShieldsQty, in: 20...160, step: 2)
                    Stepper("Длительность: \(NumberFormatting.two(settings.shiftDurationHours)) ч", value: $settings.shiftDurationHours, in: 6...16, step: 0.5)
                    Stepper("Итерации отжига: \(settings.iterations)", value: $settings.iterations, in: 20...1500, step: 20)
                }

                InfoTipView(
                    title: "Что менять диспетчеру в первую очередь",
                    message: "Для демонстрации обычно достаточно менять план, начальные остатки перед C3/C4 и число итераций. Если C3 простаивает, итоговая отгрузка почти всегда падает."
                )

                SectionCard("Начальные остатки", subtitle: "Полуфабрикаты на старте смены") {
                    Stepper("Щитов в C2: \(settings.initialC2)", value: $settings.initialC2, in: 0...80)
                    Stepper("Щитов в C3: \(settings.initialC3)", value: $settings.initialC3, in: 0...80)
                    Stepper("Готовых в C4: \(settings.initialC4)", value: $settings.initialC4, in: 0...80)
                }

                SectionCard("Узкое место", subtitle: "Производительность C3") {
                    VStack(alignment: .leading) {
                        Text("C3: \(NumberFormatting.two(settings.c3RatePerHour)) щитов/час")
                            .font(.subheadline.weight(.semibold))
                        Slider(value: $settings.c3RatePerHour, in: 2...16, step: 0.5)
                    }
                }

                SectionCard("Воспроизводимость", subtitle: "Seed фиксирует случайные перестановки отжига") {
                    Stepper("Seed: \(settings.seed)", value: $settings.seed, in: 0...1_000_000)
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Сценарий")
    }
}

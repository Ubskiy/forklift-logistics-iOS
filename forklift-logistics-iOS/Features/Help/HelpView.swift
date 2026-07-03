import SwiftUI

struct HelpView: View {
    private let articles: [HelpArticle] = [
        HelpArticle(title: "Что делает приложение", message: "Отправляет параметры смены на backend, получает расчёт двух стратегий и показывает отгрузку, простой C3 и расписание погрузчиков.", icon: "shippingbox"),
        HelpArticle(title: "Жадная стратегия", message: "Выбирает ближайший доступный рейс с учётом приоритетов потока. Это быстрый базовый вариант для сравнения.", icon: "arrow.up.forward.circle"),
        HelpArticle(title: "Имитация отжига", message: "Меняет порядок рейсов, прогоняет варианты через симуляцию и сохраняет расписание с меньшим значением целевой функции.", icon: "flame"),
        HelpArticle(title: "Целевая функция", message: "Главный вклад даёт недовыпуск. Дополнительно учитываются общее время, простой C3 и штрафуемый простой погрузчиков.", icon: "function"),
        HelpArticle(title: "Простой C3", message: "C3 — узкое место. Если он ждёт входной поток, итоговая отгрузка обычно снижается.", icon: "exclamationmark.triangle"),
        HelpArticle(title: "Таймлайн", message: "Цветные блоки показывают занятость погрузчиков. По ним видно распределение маршрутов во времени.", icon: "chart.bar.xaxis"),
        HelpArticle(title: "Что менять диспетчеру", message: "Начинайте с плана, стартовых остатков перед C3/C4 и числа итераций. Если план недостижим, будет большой недовыпуск.", icon: "slider.horizontal.3")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                    HelpCard(index: index + 1, article: article)
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Справка")
    }
}

private struct HelpArticle {
    let title: String
    let message: String
    let icon: String
}

private struct HelpCard: View {
    let index: Int
    let article: HelpArticle

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.12))
                Image(systemName: article.icon)
                    .foregroundStyle(AppColors.accent)
                    .font(.headline)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 8) {
                Text("\(index). \(article.title)")
                    .font(.headline)
                    .foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(article.message)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.muted)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 126, alignment: .topLeading)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }
}

import SwiftUI

struct HelpView: View {
    private let articles = AppConstants.Text.Help.articles

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppConstants.Layout.mediumSpacing) {
                ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                    HelpCard(index: index + 1, article: article)
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .appScreen(title: AppConstants.Text.Common.helpTitle)
    }
}

private struct HelpCard: View {
    let index: Int
    let article: HelpArticleContent

    var body: some View {
        HStack(alignment: .top, spacing: AppConstants.Layout.cardSpacing) {
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(AppConstants.Opacity.helpIconBackground))
                Image(systemName: article.icon)
                    .foregroundStyle(AppColors.accent)
                    .font(.headline)
            }
            .frame(width: AppConstants.Layout.iconCircle, height: AppConstants.Layout.iconCircle)

            VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
                Text("\(index). \(article.title)")
                    .font(.headline)
                    .foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(article.message)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.muted)
                    .lineSpacing(AppConstants.Layout.tinySpacing / 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(AppConstants.Layout.cardPadding)
        .frame(maxWidth: .infinity, minHeight: AppConstants.Layout.helpCardMinHeight, alignment: .topLeading)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius, style: .continuous))
        .shadow(color: .black.opacity(AppConstants.Layout.shadowOpacity), radius: AppConstants.Layout.shadowRadius, x: .zero, y: AppConstants.Layout.shadowYOffset)
    }
}

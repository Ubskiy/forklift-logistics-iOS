import SwiftUI

enum AppColors {
    static let background = Color(red: 0.96, green: 0.97, blue: 0.94)
    static let card = Color.white
    static let ink = Color(red: 0.08, green: 0.12, blue: 0.18)
    static let muted = Color(red: 0.42, green: 0.47, blue: 0.53)
    static let accent = Color(red: 0.06, green: 0.36, blue: 0.39)
    static let warning = Color(red: 0.82, green: 0.36, blue: 0.15)
    static let success = Color(red: 0.16, green: 0.52, blue: 0.34)

    static func route(_ route: String) -> Color {
        switch route {
        case AppConstants.Route.sC1: return Color(red: 0.12, green: 0.42, blue: 0.86)
        case AppConstants.Route.c1C2: return Color(red: 0.20, green: 0.58, blue: 0.35)
        case AppConstants.Route.c2C3: return Color(red: 0.92, green: 0.55, blue: 0.16)
        case AppConstants.Route.c3C4: return Color(red: 0.78, green: 0.22, blue: 0.22)
        case AppConstants.Route.c4P: return Color(red: 0.42, green: 0.27, blue: 0.74)
        default: return Color.gray
        }
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content

    init(_ title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.cardSpacing) {
            VStack(alignment: .leading, spacing: AppConstants.Layout.tinySpacing) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppColors.ink)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.muted)
                }
            }
            content
        }
        .padding(AppConstants.Layout.cardPadding)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cardCornerRadius, style: .continuous))
        .shadow(
            color: .black.opacity(AppConstants.Layout.shadowOpacity),
            radius: AppConstants.Layout.shadowRadius,
            x: .zero,
            y: AppConstants.Layout.shadowYOffset
        )
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let tone: MetricTone

    init(title: String, value: String, subtitle: String? = nil, tone: MetricTone = .neutral) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.tone = tone
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppColors.muted)
            Text(value)
                .font(.system(size: AppConstants.Layout.metricValueFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(tone.color)
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppConstants.Layout.metricPadding)
        .background(tone.color.opacity(AppConstants.Opacity.metricBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.metricCornerRadius, style: .continuous))
    }
}

enum MetricTone {
    case neutral
    case success
    case warning
    case accent

    var color: Color {
        switch self {
        case .neutral: return AppColors.ink
        case .success: return AppColors.success
        case .warning: return AppColors.warning
        case .accent: return AppColors.accent
        }
    }
}

struct InfoTipView: View {
    let title: String
    let message: String
    let isCollapsible: Bool
    @State private var isExpanded: Bool

    init(title: String, message: String, isCollapsible: Bool = true, initiallyExpanded: Bool = false) {
        self.title = title
        self.message = message
        self.isCollapsible = isCollapsible
        _isExpanded = State(initialValue: isCollapsible ? initiallyExpanded : true)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Layout.compactSpacing) {
            Button {
                guard isCollapsible else { return }
                withAnimation(.easeInOut(duration: 0.18)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .center, spacing: AppConstants.Layout.compactSpacing) {
                    Image(systemName: AppConstants.SFIcon.tip)
                        .foregroundStyle(AppColors.warning)
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.ink)
                    Spacer()
                    if isCollapsible {
                        Image(systemName: isExpanded ? AppConstants.SFIcon.chevronDown : AppConstants.SFIcon.chevronRight)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppColors.muted)
                    }
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(AppColors.muted)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(AppConstants.Layout.tipPadding)
        .background(AppColors.warning.opacity(AppConstants.Opacity.warningBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.tipCornerRadius, style: .continuous))
    }
}

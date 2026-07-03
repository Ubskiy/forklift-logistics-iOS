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
        case "S->C1": return Color(red: 0.12, green: 0.42, blue: 0.86)
        case "C1->C2": return Color(red: 0.20, green: 0.58, blue: 0.35)
        case "C2->C3": return Color(red: 0.92, green: 0.55, blue: 0.16)
        case "C3->C4": return Color(red: 0.78, green: 0.22, blue: 0.22)
        case "C4->P": return Color(red: 0.42, green: 0.27, blue: 0.74)
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
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
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
        .padding(16)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
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
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppColors.muted)
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(tone.color)
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(tone.color.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.max.fill")
                .foregroundStyle(AppColors.warning)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.ink)
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(AppColors.muted)
            }
        }
        .padding(12)
        .background(AppColors.warning.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

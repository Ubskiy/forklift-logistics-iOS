import SwiftUI

enum ForkliftPresentation {
    static func title(for id: String) -> String {
        AppConstants.Forklift.fullTitlePrefix + number(from: id)
    }

    static func shortTitle(for id: String) -> String {
        AppConstants.Forklift.shortTitlePrefix + number(from: id)
    }

    static func color(for id: String) -> Color {
        switch id {
        case AppConstants.Forklift.firstID:
            return Color(red: 0.06, green: 0.36, blue: 0.39)
        case AppConstants.Forklift.secondID:
            return Color(red: 0.66, green: 0.29, blue: 0.12)
        default:
            return Color.gray
        }
    }

    private static func number(from id: String) -> String {
        id.replacingOccurrences(of: AppConstants.Forklift.apiPrefix, with: AppConstants.NumberFormat.empty)
    }
}

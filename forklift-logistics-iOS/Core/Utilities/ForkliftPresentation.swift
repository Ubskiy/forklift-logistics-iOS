import SwiftUI

enum ForkliftPresentation {
    static func title(for id: String) -> String {
        let number = id.replacingOccurrences(of: "FL-", with: "")
        return "Погрузчик №\(number)"
    }

    static func shortTitle(for id: String) -> String {
        let number = id.replacingOccurrences(of: "FL-", with: "")
        return "№\(number)"
    }

    static func color(for id: String) -> Color {
        switch id {
        case "FL-1": return Color(red: 0.06, green: 0.36, blue: 0.39)
        case "FL-2": return Color(red: 0.66, green: 0.29, blue: 0.12)
        default: return Color.gray
        }
    }
}

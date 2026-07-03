import Foundation

enum NumberFormatting {
    static func two(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    static func signedTwo(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return sign + two(value)
    }

    static func percent(_ value: Double) -> String {
        two(value * 100) + "%"
    }
}

import Foundation

enum NumberFormatting {
    static func two(_ value: Double) -> String {
        String(format: AppConstants.NumberFormat.twoDecimals, value)
    }

    static func signedTwo(_ value: Double) -> String {
        let sign = value >= .zero ? AppConstants.NumberFormat.plus : AppConstants.NumberFormat.empty
        return sign + two(value)
    }

    static func percent(_ value: Double) -> String {
        two(value * 100) + AppConstants.NumberFormat.percent
    }
}

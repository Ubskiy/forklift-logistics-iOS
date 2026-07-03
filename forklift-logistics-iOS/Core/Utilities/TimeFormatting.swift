import Foundation

enum TimeFormatting {
    static func minutesToHMS(_ minutes: Double) -> String {
        let totalSeconds = max(0, Int((minutes * 60).rounded()))
        let hours = totalSeconds / 3600
        let mins = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, mins, seconds)
    }

    static func compactMinutes(_ minutes: Double) -> String {
        if minutes < 60 {
            return "\(Int(minutes.rounded())) мин"
        }
        let hours = Int(minutes / 60)
        let mins = Int(minutes.rounded()) % 60
        return "\(hours) ч \(mins) мин"
    }
}

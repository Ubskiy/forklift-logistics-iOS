import Foundation

enum TimeFormatting {
    static func minutesToHMS(_ minutes: Double) -> String {
        let totalSeconds = max(0, Int((minutes * Double(AppConstants.Time.secondsInMinute)).rounded()))
        let hours = totalSeconds / AppConstants.Time.secondsInHour
        let mins = (totalSeconds % AppConstants.Time.secondsInHour) / AppConstants.Time.secondsInMinute
        let seconds = totalSeconds % AppConstants.Time.secondsInMinute
        return String(format: AppConstants.NumberFormat.hms, hours, mins, seconds)
    }

    static func compactMinutes(_ minutes: Double) -> String {
        if minutes < AppConstants.Time.minutesInHour {
            return "\(Int(minutes.rounded())) \(AppConstants.Time.minuteUnit)"
        }
        let hours = Int(minutes / AppConstants.Time.minutesInHour)
        let mins = Int(minutes.rounded()) % AppConstants.Time.minutesInHourInt
        return "\(hours) \(AppConstants.Time.hourUnit) \(mins) \(AppConstants.Time.minuteUnit)"
    }
}

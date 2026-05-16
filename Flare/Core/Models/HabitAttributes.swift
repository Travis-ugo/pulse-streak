import Foundation
import ActivityKit

struct HabitAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progressPercentage: Double
        var remainingTime: String
    }

    var habitTitle: String
    var streakCount: Int
}

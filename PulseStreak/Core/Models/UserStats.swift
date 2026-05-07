import Foundation
import SwiftData

@Model
final class UserStats {
    var id: UUID
    var momentumScore: Int
    var totalCompletions: Int
    var totalHabits: Int
    var longestGlobalStreak: Int

    init(id: UUID = UUID(), momentumScore: Int = 0, totalCompletions: Int = 0, totalHabits: Int = 0, longestGlobalStreak: Int = 0) {
        self.id = id
        self.momentumScore = momentumScore
        self.totalCompletions = totalCompletions
        self.totalHabits = totalHabits
        self.longestGlobalStreak = longestGlobalStreak
    }
}

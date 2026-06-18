import Foundation

final class UserStats: Identifiable, Codable {
    var id: UUID
    var momentumScore: Int
    var totalCompletions: Int
    var totalHabits: Int
    var longestGlobalStreak: Int
    var streakFreezes: Int

    init(id: UUID = UUID(), momentumScore: Int = 0, totalCompletions: Int = 0, totalHabits: Int = 0, longestGlobalStreak: Int = 0, streakFreezes: Int = 0) {
        self.id = id
        self.momentumScore = momentumScore
        self.totalCompletions = totalCompletions
        self.totalHabits = totalHabits
        self.longestGlobalStreak = longestGlobalStreak
        self.streakFreezes = streakFreezes
    }
}

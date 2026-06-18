import Foundation

@MainActor
class UserStatsManager {
    static let shared = UserStatsManager()
    
    private init() {}
    
    func recalculateMomentum() {
        let allHabits = DataManager.shared.habits
        
        var totalActiveStreaks = 0
        var totalCompletionsPastWeek = 0
        
        let calendar = Calendar.current
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return }
        
        for habit in allHabits {
            totalActiveStreaks += habit.streakCount
            
            if let history = habit.completionHistory {
                let recentCompletions = history.filter { $0.completedAt >= oneWeekAgo }
                totalCompletionsPastWeek += recentCompletions.count
            }
        }
        
        // Simple formula: each active streak point is 2 momentum, each recent completion is 5.
        let score = (totalActiveStreaks * 2) + (totalCompletionsPastWeek * 5)
        
        let existingStats = DataManager.shared.userStats
        existingStats.momentumScore = score
        existingStats.totalHabits = allHabits.count
        existingStats.totalCompletions = totalCompletionsPastWeek
        existingStats.longestGlobalStreak = max(existingStats.longestGlobalStreak, totalActiveStreaks)
        
        DataManager.shared.saveUserStats()
    }
}

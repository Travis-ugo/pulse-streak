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
        
        // Calculate true global streak
        let calculatedLongestStreak = calculateGlobalStreak(habits: allHabits)
        
        var existingStats = DataManager.shared.userStats
        existingStats.momentumScore = score
        existingStats.totalHabits = allHabits.count
        existingStats.totalCompletions = totalCompletionsPastWeek
        existingStats.longestGlobalStreak = max(existingStats.longestGlobalStreak, calculatedLongestStreak)
        
        DataManager.shared.userStats = existingStats
    }

    private func calculateGlobalStreak(habits: [Habit]) -> Int {
        let calendar = Calendar.current
        let allDates = habits.flatMap { $0.completionHistory ?? [] }
            .map { calendar.startOfDay(for: $0.completedAt) }
        let uniqueDates = Set(allDates).sorted(by: <)
        
        guard !uniqueDates.isEmpty else { return 0 }
        
        var currentStreak = 0
        var maxStreak = 0
        var previousDate: Date?
        
        for date in uniqueDates {
            if let prev = previousDate {
                if let nextDay = calendar.date(byAdding: .day, value: 1, to: prev),
                   calendar.isDate(date, inSameDayAs: nextDay) {
                    currentStreak += 1
                } else if calendar.isDate(date, inSameDayAs: prev) {
                    // Same day completion, ignore
                } else {
                    currentStreak = 1
                }
            } else {
                currentStreak = 1
            }
            maxStreak = max(maxStreak, currentStreak)
            previousDate = date
        }
        
        return maxStreak
    }
}

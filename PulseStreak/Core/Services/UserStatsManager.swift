import Foundation
import SwiftData

@MainActor
class UserStatsManager {
    static let shared = UserStatsManager()
    
    private init() {}
    
    func recalculateMomentum(context: ModelContext) {
        let descriptor = FetchDescriptor<Habit>()
        guard let allHabits = try? context.fetch(descriptor) else { return }
        
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
        
        let statsDescriptor = FetchDescriptor<UserStats>()
        if let existingStats = try? context.fetch(statsDescriptor).first {
            existingStats.momentumScore = score
            existingStats.totalHabits = allHabits.count
        } else {
            let newStats = UserStats(
                momentumScore: score, 
                totalCompletions: totalCompletionsPastWeek, 
                totalHabits: allHabits.count, 
                longestGlobalStreak: totalActiveStreaks // simplified for now
            )
            context.insert(newStats)
        }
        
        try? context.save()
    }
}

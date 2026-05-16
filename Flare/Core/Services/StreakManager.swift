import Foundation
import SwiftData
import SwiftUI

@MainActor
class StreakManager {
    static let shared = StreakManager()
    
    private init() {}
    
    // Evaluate if any streaks were broken due to missed days
    func evaluateStreaks(habits: [Habit], context: ModelContext) {
        let calendar = Calendar.current
        
        for habit in habits {
            guard habit.streakCount > 0 else { continue }
            guard let history = habit.completionHistory, !history.isEmpty else { 
                habit.streakCount = 0
                continue 
            }
            
            // Get the most recent completion
            let sortedCompletions = history.sorted { $0.completedAt > $1.completedAt }
            guard let lastCompletion = sortedCompletions.first else {
                habit.streakCount = 0
                continue
            }
            
            // If the last completion was today or yesterday, the streak is maintained
            if calendar.isDateInToday(lastCompletion.completedAt) || calendar.isDateInYesterday(lastCompletion.completedAt) {
                continue
            } else {
                // Check every day between the last completion and today. 
                // If any of those days was a "required" repeat day, the streak is broken.
                guard let startCheckDate = calendar.date(byAdding: .day, value: 1, to: lastCompletion.completedAt) else { continue }
                
                var currentDate = calendar.startOfDay(for: startCheckDate)
                let endOfToday = calendar.startOfDay(for: Date())
                var streakBroken = false
                
                while currentDate < endOfToday {
                    let weekday = calendar.component(.weekday, from: currentDate)
                    if habit.repeatDays.contains(weekday) {
                        streakBroken = true
                        break
                    }
                    guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                    currentDate = nextDay
                }
                
                if streakBroken {
                    // Check for Streak Freeze
                    if let stats = fetchUserStats(context: context), stats.streakFreezes > 0 {
                        stats.streakFreezes -= 1
                        
                        // Add a "frozen" completion for yesterday to protect the streak
                        let yesterday = calendar.date(byAdding: .day, value: -1, to: endOfToday)!
                        let freezeCompletion = Completion(completedAt: yesterday, status: "frozen")
                        context.insert(freezeCompletion)
                        habit.completionHistory?.append(freezeCompletion)
                        
                        // Notify user (could be via a notification or local property)
                        print("Streak Freeze consumed for \(habit.title)!")
                    } else {
                        habit.streakCount = 0
                    }
                }
            }
        }
        try? context.save()
        UserStatsManager.shared.recalculateMomentum(context: context)
    }
    
    private func fetchUserStats(context: ModelContext) -> UserStats? {
        let descriptor = FetchDescriptor<UserStats>()
        return try? context.fetch(descriptor).first
    }
    
    func toggleCompletion(for habit: Habit, context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()
        
        if habit.completionHistory == nil {
            habit.completionHistory = []
        }
        
        // Check if completed today
        let todayCompletions = habit.completionHistory!.filter { calendar.isDateInToday($0.completedAt) }
        
        if let existingCompletion = todayCompletions.first {
            // Un-complete: Remove completion for today
            context.delete(existingCompletion)
            if let index = habit.completionHistory?.firstIndex(where: { $0.id == existingCompletion.id }) {
                habit.completionHistory?.remove(at: index)
            }
            habit.streakCount = max(0, habit.streakCount - 1)
        } else {
            // Complete for today
            let completion = Completion(completedAt: today, status: "completed")
            context.insert(completion)
            habit.completionHistory?.append(completion)
            
            habit.streakCount += 1
            if habit.streakCount > habit.longestStreak {
                habit.longestStreak = habit.streakCount
            }
            
            // Haptic Feedback
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
        
        try? context.save()
        
        // Notify stats manager to update momentum
        UserStatsManager.shared.recalculateMomentum(context: context)
    }
    
    func isCompletedToday(habit: Habit) -> Bool {
        guard let history = habit.completionHistory else { return false }
        return history.contains { Calendar.current.isDateInToday($0.completedAt) }
    }
}

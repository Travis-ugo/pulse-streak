import Foundation
import Combine
import WidgetKit

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
            updateWidgetData()
        }
    }
    
    @Published var userStats: UserStats = UserStats() {
        didSet {
            saveUserStats()
            updateWidgetData()
        }
    }
    
    private let habitsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("habits.json")
    private let statsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("userStats.json")
    
    private init() {
        loadData()
    }
    
    func loadData() {
        // Load habits
        if let data = try? Data(contentsOf: habitsURL),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            self.habits = decoded
        } else {
            self.habits = []
        }
        
        // Load stats
        if let data = try? Data(contentsOf: statsURL),
           let decoded = try? JSONDecoder().decode(UserStats.self, from: data) {
            self.userStats = decoded
        } else {
            self.userStats = UserStats()
        }
    }
    
    func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            try? encoded.write(to: habitsURL)
        }
    }
    
    func saveUserStats() {
        if let encoded = try? JSONEncoder().encode(userStats) {
            try? encoded.write(to: statsURL)
        }
    }
    
    func insert(_ habit: Habit) {
        habits.append(habit)
    }
    
    func delete(_ habit: Habit) {
        NotificationManager.shared.cancelReminder(for: habit.id.uuidString)
        habits.removeAll { $0.id == habit.id }
    }
    
    // Explicit trigger to save when deep properties change (like completions)
    func updateHabit(_ habit: Habit) {
        if let idx = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[idx] = habit
        } else {
            saveHabits()
            updateWidgetData()
        }
    }
    
    func save() {
        saveHabits()
        saveUserStats()
    }
    
    func updateWidgetData() {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.flare.streak") else { return }
        
        // Calculate longest streak
        let longestStreak = habits.map { $0.streakCount }.max() ?? 0
        
        // Calculate consistency percentage (last 7 days)
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        var totalCompleted = 0
        for habit in habits {
            if let history = habit.completionHistory {
                let completedInRange = history.filter { $0.completedAt >= sevenDaysAgo }
                totalCompleted += completedInRange.count
            }
        }
        
        let totalPossible = habits.count * 7
        let consistency = totalPossible > 0 ? Int((Double(totalCompleted) / Double(totalPossible)) * 100) : 0
        
        // Calculate weekly progress (past 7 days, ending with today)
        let today = calendar.startOfDay(for: Date())
        var weeklyProgress: [Double] = []
        for i in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else {
                weeklyProgress.append(0.0)
                continue
            }
            let totalHabitsForDay = habits.count
            guard totalHabitsForDay > 0 else {
                weeklyProgress.append(0.0)
                continue
            }
            var completedCount = 0
            for habit in habits {
                if let history = habit.completionHistory,
                   history.contains(where: { calendar.isDate($0.completedAt, inSameDayAs: date) }) {
                    completedCount += 1
                }
            }
            let fraction = Double(completedCount) / Double(totalHabitsForDay)
            weeklyProgress.append(fraction)
        }
        
        // Calculate heatmap values for the last 4 weeks (4 rows, 12 columns = 48 days)
        var heatmapData: [Int] = Array(repeating: 0, count: 48)
        for row in 0..<4 {
            for col in 0..<12 {
                let offset = (3 - row) * 12 + (11 - col)
                if let checkDate = calendar.date(byAdding: .day, value: -offset, to: today) {
                    let totalHabitsForDay = habits.count
                    if totalHabitsForDay > 0 {
                        var completedForDay = 0
                        for habit in habits {
                            if let history = habit.completionHistory,
                               history.contains(where: { calendar.isDate($0.completedAt, inSameDayAs: checkDate) }) {
                                completedForDay += 1
                            }
                        }
                        if completedForDay == totalHabitsForDay {
                            heatmapData[row * 12 + col] = 2
                        } else if completedForDay > 0 {
                            heatmapData[row * 12 + col] = 1
                        }
                    }
                }
            }
        }
        
        // Calculate total days with at least one completion
        var uniqueCompletedDates = Set<DateComponents>()
        for habit in habits {
            if let history = habit.completionHistory {
                for completion in history {
                    let components = calendar.dateComponents([.year, .month, .day], from: completion.completedAt)
                    uniqueCompletedDates.insert(components)
                }
            }
        }
        let totalDays = uniqueCompletedDates.count
        
        // Save to shared UserDefaults
        sharedDefaults.set(longestStreak, forKey: "streakCount")
        sharedDefaults.set(consistency, forKey: "consistencyPercentage")
        sharedDefaults.set(userStats.momentumScore, forKey: "momentumScore")
        sharedDefaults.set(weeklyProgress, forKey: "weeklyProgress")
        sharedDefaults.set(heatmapData, forKey: "heatmapData")
        sharedDefaults.set(totalDays, forKey: "totalDaysWithCompletions")
        
        // Reload all widget timelines
        WidgetCenter.shared.reloadAllTimelines()
    }
}

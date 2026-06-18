import Foundation
import Combine

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }
    
    @Published var userStats: UserStats = UserStats() {
        didSet {
            saveUserStats()
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
        habits.removeAll { $0.id == habit.id }
    }
    
    // Explicit trigger to save when deep properties change (like completions)
    func updateHabit(_ habit: Habit) {
        if let idx = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[idx] = habit
        } else {
            saveHabits()
        }
    }
    
    func save() {
        saveHabits()
        saveUserStats()
    }
}

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var icon: String
    var colorHex: String
    var repeatDays: [Int] // 1 = Sunday, 2 = Monday, etc.
    var reminderTimes: [Date]
    var streakCount: Int
    var longestStreak: Int
    
    @Relationship(deleteRule: .cascade) 
    var completionHistory: [Completion]?
    
    var createdAt: Date

    init(id: UUID = UUID(), 
         title: String, 
         icon: String = "flame.fill", 
         colorHex: String = "#FF9F0A", 
         repeatDays: [Int] = [1, 2, 3, 4, 5, 6, 7], 
         reminderTimes: [Date] = [], 
         streakCount: Int = 0, 
         longestStreak: Int = 0, 
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorHex = colorHex
        self.repeatDays = repeatDays
        self.reminderTimes = reminderTimes
        self.streakCount = streakCount
        self.longestStreak = longestStreak
        self.createdAt = createdAt
    }
}

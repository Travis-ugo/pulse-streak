import Foundation

enum GroupTaskType: String, Codable, CaseIterable {
    case shared = "Shared Task"
    case individual = "Individual Task"
}

struct StreakGroup: Identifiable, Codable {
    let id: String
    var name: String
    var creatorId: String
    var memberIds: [String]
    var taskType: GroupTaskType
    var sharedTaskName: String? // Only used if taskType is .shared
    var streakCount: Int
    var lastStreakUpdate: Date?
    var createdAt: Date
    
    // Member completion status for today: [UserId: CompletionDate]
    var memberCompletions: [String: Date]
}

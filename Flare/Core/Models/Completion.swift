import Foundation
import SwiftData

@Model
final class Completion {
    var id: UUID
    var completedAt: Date
    var status: String // "completed", "skipped", "missed"
    
    // Inverse relationship back to Habit
    var habit: Habit?

    init(id: UUID = UUID(), completedAt: Date = Date(), status: String = "completed") {
        self.id = id
        self.completedAt = completedAt
        self.status = status
    }
}

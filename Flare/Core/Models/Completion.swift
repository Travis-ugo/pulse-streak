import Foundation

final class Completion: Identifiable, Codable {
    var id: UUID
    var completedAt: Date
    var status: String // "completed", "skipped", "missed"

    init(id: UUID = UUID(), completedAt: Date = Date(), status: String = "completed") {
        self.id = id
        self.completedAt = completedAt
        self.status = status
    }
}

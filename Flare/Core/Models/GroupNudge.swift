import Foundation

struct GroupNudge: Codable, Identifiable {
    let id: String
    let groupId: String
    let groupName: String
    let senderId: String
    let senderName: String
    let receiverId: String
    let createdAt: Date
}

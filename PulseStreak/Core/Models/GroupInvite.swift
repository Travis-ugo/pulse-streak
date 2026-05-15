import Foundation

enum InviteStatus: String, Codable {
    case pending
    case accepted
    case declined
}

struct GroupInvite: Identifiable, Codable {
    let id: String
    let groupId: String
    let groupName: String
    let senderId: String
    let senderName: String
    let receiverEmail: String
    var status: InviteStatus
    let createdAt: Date
}

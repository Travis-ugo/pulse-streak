import Foundation

struct User: Identifiable, Codable {
    let id: String // Firebase UID
    var email: String
    var displayName: String?
    var photoURL: String?
    var joinedAt: Date
    
    var initials: String {
        let name = displayName ?? email
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            return "\(components[0].prefix(1))\(components[1].prefix(1))".uppercased()
        } else {
            return String(name.prefix(1)).uppercased()
        }
    }
}

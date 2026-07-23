import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore

@MainActor
class GroupManager: ObservableObject {
    static let shared = GroupManager()
    
    @Published var groups: [StreakGroup] = []
    @Published var pendingInvites: [GroupInvite] = []
    @Published var activeNudges: [GroupNudge] = []
    
    private var db: Firestore { Firestore.firestore() }
    private var groupsListener: ListenerRegistration?
    private var invitesListener: ListenerRegistration?
    private var nudgesListener: ListenerRegistration?
    
    private init() {}
    
    func startListening(userId: String) {
        guard FirebaseApp.app() != nil else { return }
        guard groupsListener == nil else { return }
        
        // Listen for groups where user is a member
        groupsListener = db.collection("groups")
            .whereField("memberIds", arrayContains: userId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let fetchedGroups = documents.compactMap { try? $0.data(as: StreakGroup.self) }
                self.groups = fetchedGroups
                self.evaluateGroupStreaks(fetchedGroups)
            }
        
        // Listen for invites for user's email
        if let email = AuthManager.shared.currentUser?.email {
            invitesListener = db.collection("invites")
                .whereField("receiverEmail", isEqualTo: email)
                .whereField("status", isEqualTo: "pending")
                .addSnapshotListener { snapshot, error in
                    guard let documents = snapshot?.documents else { return }
                    self.pendingInvites = documents.compactMap { try? $0.data(as: GroupInvite.self) }
                }
        }
        
        // Listen for nudges sent to this user
        nudgesListener = db.collection("nudges")
            .whereField("receiverId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.activeNudges = documents.compactMap { try? $0.data(as: GroupNudge.self) }
            }
    }
    
    func stopListening() {
        groupsListener?.remove()
        groupsListener = nil
        invitesListener?.remove()
        invitesListener = nil
        nudgesListener?.remove()
        nudgesListener = nil
        
        self.groups = []
        self.pendingInvites = []
        self.activeNudges = []
    }
    
    func nudgeMember(memberId: String, in group: StreakGroup, sender: User) async throws {
        let nudgeId = UUID().uuidString
        let nudge = GroupNudge(
            id: nudgeId,
            groupId: group.id,
            groupName: group.name,
            senderId: sender.id,
            senderName: sender.displayName ?? "A teammate",
            receiverId: memberId,
            createdAt: Date()
        )
        
        try db.collection("nudges").document(nudgeId).setData(from: nudge)
        
        // Auto-delete nudge after 1 hour (optional, but good for cleanup)
        // In a real app, this would be a cloud function
    }
    
    func dismissNudge(_ nudgeId: String) async throws {
        try await db.collection("nudges").document(nudgeId).delete()
    }
    
    private func evaluateGroupStreaks(_ groups: [StreakGroup]) {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        for group in groups {
            guard group.streakCount > 0 else { continue }
            
            // If the last update was before yesterday, and it wasn't updated today, the streak is broken
            let lastUpdate = group.lastStreakUpdate ?? Date.distantPast
            if !Calendar.current.isDate(lastUpdate, inSameDayAs: today) && 
               !Calendar.current.isDate(lastUpdate, inSameDayAs: yesterday) {
                
                // Reset streak in Firestore
                db.collection("groups").document(group.id).updateData([
                    "streakCount": 0
                ])
            }
        }
    }
    
    func createGroup(name: String, taskType: GroupTaskType, sharedTaskName: String?, icon: String, reminderTime: Date, creator: User) async throws -> String {
        let groupId = UUID().uuidString
        let newGroup = StreakGroup(
            id: groupId,
            name: name,
            creatorId: creator.id,
            memberIds: [creator.id],
            taskType: taskType,
            sharedTaskName: sharedTaskName,
            streakCount: 0,
            lastStreakUpdate: nil,
            createdAt: Date(),
            memberCompletions: [:],
            icon: icon,
            reminderTime: reminderTime
        )
        
        try db.collection("groups").document(groupId).setData(from: newGroup)
        return groupId
    }
    
    func inviteUser(email: String, to group: StreakGroup, sender: User) async throws {
        let inviteId = UUID().uuidString
        let invite = GroupInvite(
            id: inviteId,
            groupId: group.id,
            groupName: group.name,
            senderId: sender.id,
            senderName: sender.displayName ?? sender.email,
            receiverEmail: email,
            status: .pending,
            createdAt: Date()
        )
        
        try db.collection("invites").document(inviteId).setData(from: invite)
    }
    
    func acceptInvite(_ invite: GroupInvite, userId: String) async throws {
        // Update invite status
        try await db.collection("invites").document(invite.id).updateData(["status": "accepted"])
        
        // Add user to group members
        try await db.collection("groups").document(invite.groupId).updateData([
            "memberIds": FieldValue.arrayUnion([userId])
        ])
    }
    
    func checkIn(groupId: String, userId: String) async throws {
        let today = Calendar.current.startOfDay(for: Date())
        let groupDoc = db.collection("groups").document(groupId)
        
        _ = try await db.runTransaction { (transaction, errorPointer) -> Any? in
            let groupSnapshot: DocumentSnapshot
            do {
                groupSnapshot = try transaction.getDocument(groupDoc)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
            
            guard var group = try? groupSnapshot.data(as: StreakGroup.self) else { return nil }
            
            // Update user's completion
            group.memberCompletions[userId] = Date()
            
            // Check if everyone has checked in today
            let allCheckedIn = group.memberIds.allSatisfy { memberId in
                if let completionDate = group.memberCompletions[memberId] {
                    return Calendar.current.isDate(completionDate, inSameDayAs: today)
                }
                return false
            }
            
            if allCheckedIn {
                // Check if streak was already updated today to prevent double-counting
                let lastUpdate = group.lastStreakUpdate ?? Date.distantPast
                if !Calendar.current.isDate(lastUpdate, inSameDayAs: today) {
                    group.streakCount += 1
                    group.lastStreakUpdate = Date()
                }
            }
            
            transaction.setData(try! Firestore.Encoder().encode(group), forDocument: groupDoc)
            return nil
        }
    }
}

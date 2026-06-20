import SwiftUI

struct MemberRow: View {
    let memberId: String
    let group: StreakGroup
    @State private var member: User?
    
    var body: some View {
        HStack {
            if let member = member {
                ZStack {
                    Circle()
                        .fill(Color.stitchSurface)
                        .frame(width: 40, height: 40)
                    Text(member.initials)
                        .font(.caption.bold())
                        .foregroundColor(.stitchPrimary)
                }
                
                Text(memberId == AuthManager.shared.currentUser?.id ? "You" : (member.displayName ?? "Member"))
                    .foregroundColor(.white)
            } else {
                Circle()
                    .fill(Color.stitchSurface)
                    .frame(width: 40, height: 40)
                Text("Loading...")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if hasCheckedInToday {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.stitchPrimary)
            } else if memberId != AuthManager.shared.currentUser?.id {
                Button(action: {
                    Task {
                        if let sender = AuthManager.shared.currentUser {
                            try? await GroupManager.shared.nudgeMember(memberId: memberId, in: group, sender: sender)
                        }
                    }
                }) {
                    Label("Nudge", systemImage: "bell.fill")
                        .font(.caption.bold())
                        .foregroundColor(.stitchPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.stitchPrimary.opacity(0.1))
                        .cornerRadius(8)
                }
            } else {
                Text("Not yet")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.stitchSurface.opacity(0.5))
        .cornerRadius(12)
        .onAppear {
            Task {
                member = await AuthManager.shared.fetchUser(by: memberId)
            }
        }
    }
    
    private var hasCheckedInToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        if let completionDate = group.memberCompletions[memberId] {
            return Calendar.current.isDate(completionDate, inSameDayAs: today)
        }
        return false
    }
}

struct NudgeNotificationView: View {
    let nudge: GroupNudge
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bell.badge.fill")
                .foregroundColor(.black)
                .padding(8)
                .background(Color.stitchPrimary)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(nudge.senderName) nudged you!")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("Keep the \(nudge.groupName) streak alive! 🔥")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    try? await GroupManager.shared.dismissNudge(nudge.id)
                }
            }) {
                Image(systemName: "xmark")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(hex: "#1A1A1A"))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.stitchPrimary.opacity(0.3), lineWidth: 1))
        .padding(.horizontal)
        .shadow(radius: 10)
    }
}

struct InviteView: View {
    let group: StreakGroup
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.stitchBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    Text("Invite a friend to join \(group.name)")
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("", text: $email, prompt: Text("Friend's Email").foregroundColor(Color.white.opacity(0.4)))
                            .textInputAutocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.stitchSurface)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Button(action: handleInvite) {
                        if isLoading {
                            ProgressView().tint(.black)
                        } else {
                            Text("Send Invitation")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.stitchPrimary)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .disabled(isLoading || email.isEmpty)
                    
                    Spacer()
                }
            }
            .navigationTitle("Invite Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.stitchPrimary)
                }
            }
        }
    }
    
    private func handleInvite() {
        guard let sender = AuthManager.shared.currentUser else { return }
        isLoading = true
        Task {
            do {
                try await GroupManager.shared.inviteUser(email: email, to: group, sender: sender)
                dismiss()
            } catch {
                print("Error sending invite: \(error)")
                isLoading = false
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MemberRow(
            memberId: "preview-user-id",
            group: StreakGroup(
                id: "preview-group-id",
                name: "Gym Bros",
                creatorId: "user1",
                memberIds: ["user1", "user2"],
                taskType: .shared,
                sharedTaskName: "Daily Workout",
                streakCount: 7,
                lastStreakUpdate: nil,
                createdAt: Date(),
                memberCompletions: ["preview-user-id": Date()],
                icon: "person.2.fill",
                reminderTime: nil
            )
        )
        
        NudgeNotificationView(
            nudge: GroupNudge(
                id: "nudge1",
                groupId: "preview-group-id",
                groupName: "Gym Bros",
                senderId: "sender1",
                senderName: "Bob",
                receiverId: "receiver1",
                createdAt: Date()
            )
        )
        
        InviteView(group: StreakGroup(
            id: "preview-group-id",
            name: "Gym Bros",
            creatorId: "user1",
            memberIds: ["user1", "user2"],
            taskType: .shared,
            sharedTaskName: "Daily Workout",
            streakCount: 7,
            lastStreakUpdate: nil,
            createdAt: Date(),
            memberCompletions: [:],
            icon: "person.2.fill",
            reminderTime: nil
        ))
    }
    .background(Color.stitchBackground)
}

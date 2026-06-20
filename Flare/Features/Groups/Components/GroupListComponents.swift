import SwiftUI

struct InviteCard: View {
    let invite: GroupInvite
    @ObservedObject var groupManager = GroupManager.shared
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(invite.groupName)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("from \(invite.senderName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    Task {
                        try? await groupManager.acceptInvite(invite, userId: AuthManager.shared.currentUser?.id ?? "")
                    }
                }) {
                    Text("Accept")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.stitchPrimary)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.stitchSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .padding(.horizontal)
    }
}

struct GroupCard: View {
    let group: StreakGroup
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.stitchPrimary.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: group.icon ?? "person.2.fill")
                    .foregroundColor(.stitchPrimary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(group.memberIds.count) members")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.stitchPrimary)
                    Text("\(group.streakCount)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("streak")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.stitchSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .padding(.horizontal)
    }
}

struct EmptyGroupsView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.sequence.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.stitchGradient)
            
            Text("Better Together")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Text("Streaks are easier (and fun) with friends. Create a group to start a shared journey.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: action) {
                Text("Create First Group")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.stitchPrimary)
                    .cornerRadius(20)
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InviteCard(invite: GroupInvite(id: "1", groupId: "g1", groupName: "Workout Club", senderId: "s1", senderName: "Alex", receiverEmail: "alex@example.com", status: .pending, createdAt: Date()))
        GroupCard(group: StreakGroup(id: "1", name: "Fit Crew", creatorId: "u1", memberIds: ["u1", "u2"], taskType: .individual, sharedTaskName: nil, streakCount: 5, lastStreakUpdate: nil, createdAt: Date(), memberCompletions: [:], icon: "person.2.fill", reminderTime: nil))
        EmptyGroupsView(action: {})
    }
    .background(Color.stitchBackground)
}

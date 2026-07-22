import SwiftUI

struct DashboardGroupsList: View {
    @ObservedObject var groupManager = GroupManager.shared
    @Binding var showingCreateGroup: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Streak Groups")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Spacer()
                Button(action: { showingCreateGroup = true }) {
                    Image(systemName: "plus")
                        .font(.caption.bold())
                        .foregroundColor(.stitchPrimaryBright)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if !groupManager.pendingInvites.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pending Invites")
                        .font(.caption.bold())
                        .foregroundColor(.stitchPrimaryBright)
                        .padding(.horizontal, 20)
                    
                    ForEach(groupManager.pendingInvites) { invite in
                        InviteCard(invite: invite)
                    }
                }
                .padding(.bottom, 8)
            }
            
            if groupManager.groups.isEmpty {
                VStack(spacing: 12) {
                    Text("Better together. Start a shared journey.")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#A1A1A1"))
                        .multilineTextAlignment(.center)
                    Button(action: { showingCreateGroup = true }) {
                        Text("Create Group")
                            .font(.caption.bold())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.stitchPrimary)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.stitchSurface)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                .padding(.horizontal, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(groupManager.groups) { group in
                        NavigationLink(destination: GroupDetailView(groupId: group.id)) {
                            GroupCard(group: group)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    NavigationView {
        DashboardGroupsList(showingCreateGroup: .constant(false))
            .background(Color.stitchBackground)
    }
}

import SwiftUI

struct GroupListView: View {
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    @State private var showingCreateGroup = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.stitchBackground.edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Text("Streak Groups")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.stitchGradient)
                        
                        Spacer()
                        
                        Button(action: { showingCreateGroup = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.stitchPrimary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Pending Invites Section
                            if !groupManager.pendingInvites.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Pending Invites")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    
                                    ForEach(groupManager.pendingInvites) { invite in
                                        InviteCard(invite: invite)
                                    }
                                }
                            }
                            
                            // Groups Section
                            if groupManager.groups.isEmpty {
                                EmptyGroupsView(action: { showingCreateGroup = true })
                                    .padding(.top, 40)
                            } else {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Your Groups")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    
                                    ForEach(groupManager.groups) { group in
                                        NavigationLink(destination: GroupDetailView(groupId: group.id)) {
                                            GroupCard(group: group)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreateGroup) {
                CreateGroupView()
            }
            .onAppear {
                if let userId = authManager.currentUser?.id {
                    groupManager.startListening(userId: userId)
                }
            }
        }
    }
}

struct InviteCard: View {
    let invite: GroupInvite
    @ObservedObject var groupManager = GroupManager.shared
    
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
        .background(Color.stitchSurface)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct GroupCard: View {
    let group: StreakGroup
    
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
        .background(Color.stitchSurface)
        .cornerRadius(16)
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

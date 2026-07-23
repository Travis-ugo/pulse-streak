import SwiftUI
import FirebaseCore

struct GroupListView: View {
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
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

#Preview {
    let _ = {
        // Initialize Firebase for previews if not already configured
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Mock current user
        AuthManager.shared.currentUser = User(
            id: "preview-user-id",
            email: "preview@example.com",
            displayName: "Jane Doe",
            photoURL: nil,
            joinedAt: Date()
        )
        AuthManager.shared.isLoading = false
        
        // Mock groups
        GroupManager.shared.groups = [
            StreakGroup(
                id: "preview-group-id-1",
                name: "Gym Bros",
                creatorId: "user1",
                memberIds: ["preview-user-id", "user2"],
                taskType: .shared,
                sharedTaskName: "Daily Workout",
                streakCount: 5,
                lastStreakUpdate: nil,
                createdAt: Date(),
                memberCompletions: ["preview-user-id": Date()],
                icon: "flame.fill",
                reminderTime: nil
            ),
            StreakGroup(
                id: "preview-group-id-2",
                name: "Coders",
                creatorId: "preview-user-id",
                memberIds: ["preview-user-id", "user3"],
                taskType: .individual,
                sharedTaskName: nil,
                streakCount: 3,
                lastStreakUpdate: nil,
                createdAt: Date(),
                memberCompletions: [:],
                icon: "keyboard.fill",
                reminderTime: nil
            )
        ]
        
        // Mock pending invites
        GroupManager.shared.pendingInvites = [
            GroupInvite(
                id: "invite1",
                groupId: "group3",
                groupName: "Early Risers",
                senderId: "user4",
                senderName: "Alice",
                receiverEmail: "preview@example.com",
                status: .pending,
                createdAt: Date()
            )
        ]
    }()
    
    return GroupListView()
}

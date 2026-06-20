import SwiftUI

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
    GroupListView()
}

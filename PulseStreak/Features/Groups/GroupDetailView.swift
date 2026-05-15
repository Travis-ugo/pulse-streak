import SwiftUI

struct GroupDetailView: View {
    let group: StreakGroup
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var inviteEmail = ""
    @State private var showingInviteSheet = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.stitchSurface, lineWidth: 8)
                                .frame(width: 150, height: 150)
                            
                            VStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.stitchGradient)
                                
                                Text("\(group.streakCount)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("DAYS")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .tracking(2)
                            }
                        }
                        .padding(.top, 20)
                        
                        Text(group.name)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        if group.taskType == .shared {
                            Text(group.sharedTaskName ?? "")
                                .font(.subheadline)
                                .foregroundColor(.stitchPrimary)
                        } else {
                            Text("Individual Goals")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Check-in Button
                    if !hasCheckedInToday {
                        Button(action: handleCheckIn) {
                            if isLoading {
                                ProgressView().tint(.black)
                            } else {
                                Text("Check In for Today")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.stitchPrimary)
                        .cornerRadius(30)
                        .padding(.horizontal)
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.stitchPrimary)
                            Text("You're checked in!")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.stitchSurface)
                        .cornerRadius(30)
                        .padding(.horizontal)
                    }
                    
                    // Members Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Members")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: { showingInviteSheet = true }) {
                                Label("Invite", systemImage: "person.badge.plus")
                                    .font(.caption.bold())
                                    .foregroundColor(.stitchPrimary)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            ForEach(group.memberIds, id: \.self) { memberId in
                                MemberRow(memberId: memberId, group: group)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingInviteSheet) {
            InviteView(group: group)
        }
    }
    
    private var hasCheckedInToday: Bool {
        guard let userId = authManager.currentUser?.id,
              let lastCompletion = group.memberCompletions[userId] else { return false }
        return Calendar.current.isDateInToday(lastCompletion)
    }
    
    private func handleCheckIn() {
        guard let userId = authManager.currentUser?.id else { return }
        isLoading = true
        Task {
            do {
                try await groupManager.checkIn(groupId: group.id, userId: userId)
                isLoading = false
            } catch {
                print("Error checking in: \(error)")
                isLoading = false
            }
        }
    }
}

struct MemberRow: View {
    let memberId: String
    let group: StreakGroup
    
    var body: some View {
        HStack {
            // In a real app, we'd fetch the user's display name from Firestore
            // For now, we'll just show the ID or a placeholder
            Circle()
                .fill(Color.stitchSurface)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )
            
            Text(memberId == AuthManager.shared.currentUser?.id ? "You" : "Member")
                .foregroundColor(.white)
            
            Spacer()
            
            if hasCheckedInToday {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.stitchPrimary)
            } else {
                Text("Not yet")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.stitchSurface.opacity(0.5))
        .cornerRadius(12)
    }
    
    private var hasCheckedInToday: Bool {
        guard let lastCompletion = group.memberCompletions[memberId] else { return false }
        return Calendar.current.isDateInToday(lastCompletion)
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
                        TextField("Friend's Email", text: $email)
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

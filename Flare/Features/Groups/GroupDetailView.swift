import SwiftUI

struct GroupDetailView: View {
    let groupId: String
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var showingInviteSheet = false
    @State private var isLoading = false
    
    private var group: StreakGroup? {
        groupManager.groups.first(where: { $0.id == groupId })
    }
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            if let group = group {
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
                        if !hasCheckedInToday(group: group) {
                            Button(action: { handleCheckIn(group: group) }) {
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
                        
                        // Accountability Warning
                        if !allMembersCheckedIn(group: group) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Don't let the team streak die!")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.orange.opacity(0.15))
                            .cornerRadius(12)
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
                .sheet(isPresented: $showingInviteSheet) {
                    InviteView(group: group)
                }
                .overlay(
                    VStack {
                        ForEach(groupManager.activeNudges) { nudge in
                            NudgeNotificationView(nudge: nudge)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                )
            } else {
                ProgressView().tint(.stitchPrimary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func allMembersCheckedIn(group: StreakGroup) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return group.memberIds.allSatisfy { memberId in
            if let completionDate = group.memberCompletions[memberId] {
                return Calendar.current.isDate(completionDate, inSameDayAs: today)
            }
            return false
        }
    }
    
    private func hasCheckedInToday(group: StreakGroup) -> Bool {
        guard let userId = authManager.currentUser?.id,
              let lastCompletion = group.memberCompletions[userId] else { return false }
        return Calendar.current.isDateInToday(lastCompletion)
    }
    
    private func handleCheckIn(group: StreakGroup) {
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

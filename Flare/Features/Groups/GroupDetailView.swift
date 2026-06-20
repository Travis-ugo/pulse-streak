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
#Preview {
    NavigationView {
        GroupDetailView(groupId: "preview-group-id")
    }
    .onAppear {
        GroupManager.shared.groups = [
            StreakGroup(
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
            )
        ]
    }
}

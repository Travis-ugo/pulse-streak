import SwiftUI
import Combine

struct GroupDetailView: View {
    let groupId: String
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var showingInviteSheet = false
    @State private var isLoading = false
    @State private var holdProgress: Double = 0.0
    @State private var isPressing = false
    private let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
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
                                // 1. Connecting lines drawn from center to each member avatar position
                                ForEach(Array(group.memberIds.enumerated()), id: \.element) { index, memberId in
                                    let hasCompleted = hasMemberCheckedInToday(memberId: memberId, group: group)
                                    let angle = Double(index) * (2.0 * .pi / Double(group.memberIds.count)) - .pi / 2.0
                                    
                                    ConnectingLineShape(angle: angle, radius: 110)
                                        .stroke(
                                            hasCompleted ? Color.stitchYellow.opacity(0.8) : Color.stitchSurface,
                                            style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: hasCompleted ? [] : [4, 4])
                                        )
                                }
                                
                                // 2. Central streak circle (opaque background hides line starts)
                                ZStack {
                                    Circle()
                                        .fill(Color.stitchBackground)
                                    Circle()
                                        .stroke(Color.stitchSurface, lineWidth: 8)
                                }
                                .frame(width: 150, height: 150)
                                
                                VStack(spacing: 4) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(Color.stitchGradient)
                                        .scaleEffect(hasCheckedInToday(group: group) ? 1.25 : 1.0 + CGFloat(holdProgress * 0.25))
                                        .shadow(color: hasCheckedInToday(group: group) ? Color.stitchPrimary.opacity(0.8) : Color.clear, radius: 10)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: holdProgress)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasCheckedInToday(group: group))
                                    
                                    Text("\(group.streakCount)")
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .scaleEffect(hasCheckedInToday(group: group) ? 1.1 : 1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasCheckedInToday(group: group))
                                    
                                    Text("DAYS")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .tracking(2)
                                }
                                
                                // 3. Radial members avatars
                                ForEach(Array(group.memberIds.enumerated()), id: \.element) { index, memberId in
                                    let hasCompleted = hasMemberCheckedInToday(memberId: memberId, group: group)
                                    let angle = Double(index) * (2.0 * .pi / Double(group.memberIds.count)) - .pi / 2.0
                                    let xOffset = 110.0 * cos(angle)
                                    let yOffset = 110.0 * sin(angle)
                                    
                                    OrbitalMemberAvatar(memberId: memberId, hasCompleted: hasCompleted, group: group)
                                        .offset(x: xOffset, y: yOffset)
                                }
                            }
                            .frame(width: 290, height: 290)
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
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.stitchSurface)
                                    .frame(width: 220, height: 50)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.stitchPrimary.opacity(0.3), lineWidth: 1.5)
                                    )
                                
                                Capsule()
                                    .fill(Color.stitchPrimary)
                                    .frame(width: 220 * CGFloat(holdProgress), height: 50)
                                    .animation(.interactiveSpring(response: 0.12, dampingFraction: 0.85), value: holdProgress)
                                
                                Group {
                                    if isLoading {
                                        ProgressView().tint(.black)
                                    } else {
                                        Text("Hold to Check In")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(holdProgress > 0.5 ? .black : .white)
                                    }
                                }
                                .frame(width: 220, height: 50, alignment: .center)
                            }
                            .contentShape(Capsule())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if !isLoading && !isPressing && holdProgress < 1.0 {
                                            isPressing = true
                                            let haptic = UIImpactFeedbackGenerator(style: .light)
                                            haptic.impactOccurred()
                                        }
                                    }
                                    .onEnded { _ in
                                        isPressing = false
                                    }
                            )
                        } else {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.stitchPrimary)
                                Text("Checked In!")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 220, height: 50)
                            .background(Color.stitchSurface)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.stitchPrimary.opacity(0.3), lineWidth: 1.5)
                            )
                        }
                        
                        // Members Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Members")
                                .font(.headline)
                                .foregroundColor(.white)
                            
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let group = group {
                    Button(action: { showingInviteSheet = true }) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.stitchPrimary)
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            guard let group = group else { return }
            
            // If holdProgress is already 1.0, lock it. Do not drain or modify it anymore.
            if holdProgress >= 1.0 {
                return
            }
            
            if isPressing {
                if holdProgress < 1.0 {
                    holdProgress += 0.02
                    if holdProgress >= 1.0 {
                        holdProgress = 1.0
                        
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        handleCheckIn(group: group)
                    }
                }
            } else {
                if holdProgress > 0.0 {
                    holdProgress = max(0.0, holdProgress - 0.08)
                }
            }
        }
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
    
    private func hasMemberCheckedInToday(memberId: String, group: StreakGroup) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        if let completionDate = group.memberCompletions[memberId] {
            return Calendar.current.isDate(completionDate, inSameDayAs: today)
        }
        return false
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
                await MainActor.run {
                    withAnimation {
                        holdProgress = 0.0
                        isPressing = false
                    }
                }
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
                memberIds: ["user1", "user2", "user3", "user4"],
                taskType: .shared,
                sharedTaskName: "Daily Workout",
                streakCount: 7,
                lastStreakUpdate: nil,
                createdAt: Date(),
                memberCompletions: [
                    "user1": Date(),
                    "user3": Date()
                ],
                icon: "person.2.fill",
                reminderTime: nil
            )
        ]
    }
}

struct ConnectingLineShape: Shape {
    let angle: Double
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let endPoint = CGPoint(
            x: center.x + radius * CGFloat(cos(angle)),
            y: center.y + radius * CGFloat(sin(angle))
        )
        path.move(to: center)
        path.addLine(to: endPoint)
        return path
    }
}


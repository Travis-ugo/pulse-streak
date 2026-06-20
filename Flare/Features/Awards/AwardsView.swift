import SwiftUI

struct AwardsView: View {
    @EnvironmentObject private var dataManager: DataManager
    private var habits: [Habit] { dataManager.habits }
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @State private var showingProfile = false
    @ObservedObject private var authManager = AuthManager.shared
    
    private var profileUIImage: UIImage? {
        guard let photoURL = authManager.currentUser?.photoURL else { return nil }
        return UIImage.fromBase64(photoURL)
    }
    
    private var completionsCount: Int {
        habits.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var currentXP: Int {
        completionsCount * 50
    }
    
    private var nextXP: Int {
        let nextLevelXP = ((currentXP / 1000) + 1) * 1000
        return nextLevelXP == 0 ? 1000 : nextLevelXP
    }
    
    private var currentLevel: Int {
        (currentXP / 1000) + 1
    }
    
    private var peakMomentum: Int {
        habits.map(\.longestStreak).max() ?? 0
    }
    
    private var meditateCompletions: Int {
        habits.filter { 
            $0.title.localizedCaseInsensitiveContains("meditat") || 
            $0.icon.localizedCaseInsensitiveContains("brain") 
        }.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var workoutCompletions: Int {
        habits.filter { 
            $0.title.localizedCaseInsensitiveContains("workout") || 
            $0.title.localizedCaseInsensitiveContains("gym") || 
            $0.icon.localizedCaseInsensitiveContains("dumbbell") 
        }.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var badges: [Badge] {
        [
            Badge(iconText: "7", iconName: nil, title: "7 Day Streak", 
                  subtitle: habits.contains(where: { $0.longestStreak >= 7 }) ? "Ignition phase complete" : "Keep pushing!", 
                  isUnlocked: habits.contains(where: { $0.longestStreak >= 7 })),
            Badge(iconText: "30", iconName: nil, title: "30 Day Streak", 
                  subtitle: habits.contains(where: { $0.longestStreak >= 30 }) ? "Consistency master" : "Locked", 
                  isUnlocked: habits.contains(where: { $0.longestStreak >= 30 })),
            Badge(iconText: "90", iconName: nil, title: "90 Day Streak", 
                  subtitle: habits.contains(where: { $0.longestStreak >= 90 }) ? "Habit hardened" : "Locked", 
                  isUnlocked: habits.contains(where: { $0.longestStreak >= 90 })),
            Badge(iconText: "365", iconName: nil, title: "365 Day Streak", 
                  subtitle: habits.contains(where: { $0.longestStreak >= 365 }) ? "Unstoppable force" : "Locked", 
                  isUnlocked: habits.contains(where: { $0.longestStreak >= 365 })),
            Badge(iconText: nil, iconName: "brain.head.profile", title: "Mind Palace", 
                  subtitle: meditateCompletions >= 50 ? "50 Meditations" : "\(meditateCompletions)/50 Meditations", 
                  isUnlocked: meditateCompletions >= 50),
            Badge(iconText: nil, iconName: "dumbbell.fill", title: "Iron Will", 
                  subtitle: workoutCompletions >= 200 ? "200 Workouts" : "\(workoutCompletions)/200 Workouts", 
                  isUnlocked: workoutCompletions >= 200)
        ]
    }
    
    private var unlockedCount: Int {
        badges.filter(\.isUnlocked).count
    }
    
    private var rankName: String {
        switch currentLevel {
        case 1:
            return "Bronze\nRank"
        case 2...3:
            return "Silver\nRank"
        case 4...5:
            return "Gold\nRank"
        case 6...10:
            return "Platinum\nRank"
        default:
            return "Diamond\nRank"
        }
    }
    
    private var nextRankName: String {
        switch currentLevel {
        case 1:
            return "Next: Silver"
        case 2...3:
            return "Next: Gold"
        case 4...5:
            return "Next: Platinum"
        case 6...10:
            return "Next: Diamond"
        default:
            return "Max Rank"
        }
    }
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    AwardsHeader(
                        profileUIImage: profileUIImage,
                        initials: authManager.currentUser?.initials ?? "U",
                        onProfileTap: { showingProfile = true }
                    )
                    
                    // Current Rank Card
                    AwardsRankCard(
                        rankName: rankName,
                        nextRankName: nextRankName,
                        currentXP: currentXP,
                        nextXP: nextXP
                    )
                    
                    // Milestone Badges Header
                    HStack {
                        Text("Milestone Badges")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(unlockedCount) UNLOCKED")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#DCB8FF"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.stitchSecondary.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Badges Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(badges) { badge in
                            BadgeCard(badge: badge)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Peak Momentum Card
                    AwardsPeakMomentumCard(peakMomentum: peakMomentum)
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
        }
    }
}

#Preview {
    AwardsView()
        .environmentObject(DataManager.shared)
}

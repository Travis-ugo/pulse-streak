import SwiftUI

struct CalendarView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject private var dataManager: DataManager
    private var habits: [Habit] { dataManager.habits }
    
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @State private var showingProfile = false
    @ObservedObject private var authManager = AuthManager.shared
    
    private var profileUIImage: UIImage? {
        guard let photoURL = authManager.currentUser?.photoURL else { return nil }
        return UIImage.fromBase64(photoURL)
    }
    
    private var totalHabitsCrushed: Int {
        habits.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var currentStreak: Int {
        habits.map { $0.streakCount }.max() ?? 0
    }
    
    private var longestStreak: Int {
        habits.map { $0.longestStreak }.max() ?? 0
    }
    
    private var currentStreakStatus: String {
        if currentStreak == 0 {
            return "Start your streak!"
        } else if currentStreak >= 30 {
            return "Elite Status 🔥"
        } else if currentStreak >= 15 {
            return "Unstoppable ⚡️"
        } else if currentStreak >= 7 {
            return "Consistency Master 🌟"
        } else if currentStreak >= 3 {
            return "Active Momentum ✨"
        } else {
            return "Keep the flame alive!"
        }
    }
    
    private var initiateState: TimelineState {
        if longestStreak >= 7 {
            return longestStreak < 100 ? .active : .past
        } else {
            return .locked
        }
    }
    
    private var centurionState: TimelineState {
        if longestStreak >= 100 {
            return longestStreak < 365 ? .active : .past
        } else {
            return .locked
        }
    }
    
    private var masterState: TimelineState {
        if longestStreak >= 365 {
            return .active
        } else {
            return .locked
        }
    }
    
    private var initiateDate: String {
        longestStreak >= 7 ? "ACHIEVED" : "\(longestStreak)/7 DAYS"
    }
    
    private var centurionDate: String {
        longestStreak >= 100 ? "ACHIEVED" : "\(longestStreak)/100 DAYS"
    }
    
    private var masterDate: String {
        longestStreak >= 365 ? "ACHIEVED" : "\(longestStreak)/365 DAYS"
    }
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    CalendarHeader(
                        profileUIImage: profileUIImage,
                        initials: authManager.currentUser?.initials ?? "U",
                        onProfileTap: { showingProfile = true }
                    )
                    
                    // Pulse Matrix
                    CalendarPulseMatrixCard(
                        totalHabitsCrushed: totalHabitsCrushed,
                        habits: habits
                    )
                    
                    // Streak Stats Header
                    CalendarStatsHeader(
                        currentStreak: currentStreak,
                        longestStreak: longestStreak,
                        currentStreakStatus: currentStreakStatus
                    )
                    
                    // Streak Journey
                    CalendarJourneyTimeline(
                        initiateDate: initiateDate,
                        centurionDate: centurionDate,
                        masterDate: masterDate,
                        initiateState: initiateState,
                        centurionState: centurionState,
                        masterState: masterState
                    )
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
    CalendarView(selectedTab: .constant(1))
        .environmentObject(DataManager.shared)
}

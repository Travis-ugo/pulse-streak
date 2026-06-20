import SwiftUI

struct DashboardView: View {
    var habits: [Habit]
    @Binding var selectedTab: Int
    @EnvironmentObject private var dataManager: DataManager
    
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @State private var showingAddHabit = false
    @State private var showingProfile = false
    @State private var showingCreateGroup = false
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    private var profileUIImage: UIImage? {
        guard let photoURL = authManager.currentUser?.photoURL else { return nil }
        return UIImage.fromBase64(photoURL)
    }
    
    private var userGreetingName: String {
        if let name = authManager.currentUser?.displayName, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return name
        }
        if let email = authManager.currentUser?.email, !email.isEmpty {
            return email.components(separatedBy: "@").first ?? "Explorer"
        }
        return "Explorer"
    }
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String
        if hour < 12 {
            timeGreeting = "Good Morning"
        } else if hour < 17 {
            timeGreeting = "Good Afternoon"
        } else {
            timeGreeting = "Good Evening"
        }
        return "\(timeGreeting), \(userGreetingName)"
    }
    
    private var completionsCount: Int {
        habits.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var currentXP: Int {
        completionsCount * 50
    }
    
    private var currentLevel: Int {
        (currentXP / 1000) + 1
    }
    
    private var rankName: String {
        switch currentLevel {
        case 1:
            return "Bronze Rank"
        case 2...3:
            return "Silver Rank"
        case 4...5:
            return "Gold Rank"
        case 6...10:
            return "Platinum Rank"
        default:
            return "Diamond Rank"
        }
    }
    
    private var consistencyScore: String {
        guard !habits.isEmpty else { return "+0%" }
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        var totalCompleted = 0
        for habit in habits {
            if let history = habit.completionHistory {
                let completedInRange = history.filter { $0.completedAt >= sevenDaysAgo }
                totalCompleted += completedInRange.count
            }
        }
        
        let totalPossible = habits.count * 7
        guard totalPossible > 0 else { return "+0%" }
        
        let percentage = (Double(totalCompleted) / Double(totalPossible)) * 100
        return String(format: "+%.0f%%", percentage)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Custom Header
                    DashboardHeader(
                        profileUIImage: profileUIImage,
                        initials: authManager.currentUser?.initials ?? "U",
                        onProfileTap: { showingProfile = true }
                    )
                    
                    // 2. Greeting
                    DashboardGreeting(greetingMessage: greetingMessage)
                    
                    // 3. Main Streak Card
                    DashboardStreakCard(
                        longestStreak: calculateLongestStreak(),
                        rankName: rankName,
                        todayProgress: calculateTodayProgress()
                    )
                    
                    // 4. Metric Cards
                    DashboardMetricCards(
                        momentumScore: dataManager.userStats.momentumScore,
                        consistencyScore: consistencyScore
                    )
                    
                    // 5. Today's Habits
                    DashboardHabitsList(habits: habits)
                    
                    // Streak Groups Section
                    DashboardGroupsList(showingCreateGroup: $showingCreateGroup)
                    
                    // 6. This Week Tracker
                    DashboardWeekTracker(weekDays: getWeekDays())
                        .padding(.bottom, 100) // Padding for FAB
                }
                .padding(.vertical)
            }
            
            // 7. Floating Action Button
            Button(action: {
                showingAddHabit = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.stitchGradient)
                        .frame(width: 64, height: 64)
                        .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 15, x: 0, y: 10)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
            .sheet(isPresented: $showingAddHabit) {
                HabitCreationView()
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showingCreateGroup) {
                CreateGroupView()
            }
        }
        .background(Color.stitchBackground.edgesIgnoringSafeArea(.all))
        .onAppear {
            StreakManager.shared.evaluateStreaks(habits: habits)
            UserStatsManager.shared.recalculateMomentum()
            if let userId = authManager.currentUser?.id {
                groupManager.startListening(userId: userId)
            }
        }
    }
    
    // MARK: - Helpers
    private func calculateLongestStreak() -> Int {
        return habits.map { $0.longestStreak }.max() ?? 0
    }
    
    private func calculateTodayProgress() -> Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { StreakManager.shared.isCompletedToday(habit: $0) }.count
        return Double(completed) / Double(habits.count)
    }
    
    private func getWeekDays() -> [DashboardWeekTracker.WeekDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var days: [DashboardWeekTracker.WeekDay] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EE" // Mon, Tue, Wed
        
        for i in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let symbol = String(formatter.string(from: date).prefix(1)).uppercased() // M, T, W
            
            // Determine if completed (at least one habit completed this day)
            var isCompleted = false
            for habit in habits {
                if let history = habit.completionHistory,
                   history.contains(where: { calendar.isDate($0.completedAt, inSameDayAs: date) }) {
                    isCompleted = true
                    break
                }
            }
            
            days.append(DashboardWeekTracker.WeekDay(
                date: date,
                symbol: symbol,
                isToday: calendar.isDate(date, inSameDayAs: today),
                isCompleted: isCompleted
            ))
        }
        
        return days
    }
}

#Preview {
    DashboardView(habits: [], selectedTab: .constant(0))
        .environmentObject(DataManager.shared)
}

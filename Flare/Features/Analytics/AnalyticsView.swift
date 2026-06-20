import SwiftUI
import Charts

struct DailyCompletion: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct AnalyticsView: View {
    @EnvironmentObject private var dataManager: DataManager
    private var habits: [Habit] { dataManager.habits }
    
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @State private var selectedRange = 0 // 0 = Weekly, 1 = Monthly
    @State private var showingProfile = false
    @ObservedObject private var authManager = AuthManager.shared
    
    private var profileUIImage: UIImage? {
        guard let photoURL = authManager.currentUser?.photoURL else { return nil }
        return UIImage.fromBase64(photoURL)
    }
    
    var body: some View {
        let bestHabit = getBestHabit()
        
        return ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    AnalyticsHeader(
                        profileUIImage: profileUIImage,
                        initials: authManager.currentUser?.initials ?? "U",
                        onProfileTap: { showingProfile = true }
                    )
                    
                    // Chart Section
                    AnalyticsChartCard(
                        selectedRange: $selectedRange,
                        chartData: calculateChartData()
                    )
                    
                    // Top Metrics Section
                    AnalyticsStatsGrid(
                        bestHabitTitle: bestHabit?.title ?? "None",
                        bestHabitIcon: bestHabit?.icon ?? "star.fill",
                        bestHabitColor: bestHabit != nil ? Color(hex: bestHabit!.colorHex) : .gray,
                        longestStreak: calculateLongestStreak(),
                        completionRate: calculateCompletionRate()
                    )
                }
                .padding(.vertical)
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
        }
    }
    
    private func calculateChartData() -> [DailyCompletion] {
        let calendar = Calendar.current
        var data: [DailyCompletion] = []
        
        let today = calendar.startOfDay(for: Date())
        let daysCount = selectedRange == 0 ? 7 : 30
        
        for i in (0..<daysCount).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            
            var count = 0
            for habit in habits {
                if let history = habit.completionHistory {
                    count += history.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }.count
                }
            }
            
            data.append(DailyCompletion(date: date, count: count))
        }
        
        return data
    }
    
    private func getBestHabit() -> Habit? {
        guard !habits.isEmpty else { return nil }
        return habits.max { ($0.completionHistory?.count ?? 0) < ($1.completionHistory?.count ?? 0) }
    }
    
    private func calculateLongestStreak() -> Int {
        return habits.map { $0.longestStreak }.max() ?? 0
    }
    
    private func calculateCompletionRate() -> Int {
        guard !habits.isEmpty else { return 0 }
        
        var totalPossible = 0
        var totalCompleted = 0
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for habit in habits {
            let creationDate = calendar.startOfDay(for: habit.createdAt)
            var currentDate = creationDate
            
            while currentDate <= today {
                let weekday = calendar.component(.weekday, from: currentDate)
                if habit.repeatDays.contains(weekday) {
                    totalPossible += 1
                }
                guard let next = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = next
            }
            
            totalCompleted += habit.completionHistory?.count ?? 0
        }
        
        if totalPossible == 0 { return 0 }
        
        let rate = (Double(totalCompleted) / Double(totalPossible)) * 100
        return min(Int(rate), 100)
    }
}


#Preview {
    AnalyticsView()
        .environmentObject(DataManager.shared)
}

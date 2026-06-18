import SwiftUI

struct DashboardView: View {
    var habits: [Habit]
    @Binding var selectedTab: Int
    @EnvironmentObject private var dataManager: DataManager
    
    @State private var showingAddHabit = false
    @State private var showingProfile = false
    @State private var showingCreateGroup = false
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    private var profileUIImage: UIImage? {
        guard let photoURL = authManager.currentUser?.photoURL else { return nil }
        return loadImageFromBase64(photoURL)
    }
    
    private func loadImageFromBase64(_ base64String: String) -> UIImage? {
        let cleanString: String
        if base64String.hasPrefix("data:image") {
            let components = base64String.components(separatedBy: ",")
            if components.count > 1 {
                cleanString = components[1]
            } else {
                return nil
            }
        } else {
            cleanString = base64String
        }
        
        guard let data = Data(base64Encoded: cleanString) else { return nil }
        return UIImage(data: data)
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
                    HStack {
                        // Avatar button
                        Button(action: {
                            showingProfile = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.stitchSurface)
                                    .frame(width: 36, height: 36)
                                
                                if let uiImage = profileUIImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 36, height: 36)
                                        .clipShape(Circle())
                                } else {
                                    Text(authManager.currentUser?.initials ?? "U")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.stitchPrimaryBright)
                                }
                            }
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "flame")
                            .foregroundColor(.stitchPrimary)
                            .font(.title3)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // 2. Greeting
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greetingMessage)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("🔥")
                            .font(.title)
                        
                        Text("Your momentum is undeniable today.")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#A1A1A1"))
                    }
                    .padding(.horizontal, 20)
                    
                    // 3. Main Streak Card
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(calculateLongestStreak())")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.stitchGradient)
                                Text("Day Streak")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Image(systemName: "star.circle.fill")
                                Text(rankName)
                            }
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.stitchSecondary.opacity(0.2))
                            .foregroundColor(Color(hex: "#DCB8FF"))
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        // Progress Ring
                        ZStack {
                            ProgressRing(progress: calculateTodayProgress(), color: .stitchPrimary, lineWidth: 8)
                                .frame(width: 70, height: 70)
                                .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 10)
                            
                            Text("\(Int(calculateTodayProgress() * 100))%")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(24)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.stitchSurface)
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                        }
                    )
                    .padding(.horizontal, 20)
                    
                    // 4. Metric Cards
                    HStack(spacing: 16) {
                        // Power Score
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.stitchPrimary)
                            
                            Spacer(minLength: 20)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Power Score")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                                Text("\(dataManager.userStats.momentumScore)")
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.stitchSurface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                        
                        // Consistency
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.stitchSecondary)
                            
                            Spacer(minLength: 20)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Consistency")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                                Text(consistencyScore)
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.stitchSurface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                    }
                    .padding(.horizontal, 20)
                    
                    // 5. Today's Habits
                    HStack {
                        Text("Today's Habits")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Text("View All")
                            .font(.caption)
                            .foregroundColor(.stitchPrimaryBright)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if habits.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "flame")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No habits yet")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Tap the + button to build your momentum.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#A1A1A1"))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(habits) { habit in
                                EmberCardView(habit: habit)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Streak Groups Section
                    HStack {
                        Text("Streak Groups")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: { showingCreateGroup = true }) {
                            Image(systemName: "plus")
                                .font(.caption.bold())
                                .foregroundColor(.stitchPrimaryBright)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if groupManager.groups.isEmpty {
                        VStack(spacing: 12) {
                            Text("Better together. Start a shared journey.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#A1A1A1"))
                                .multilineTextAlignment(.center)
                            Button(action: { showingCreateGroup = true }) {
                                Text("Create Group")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.stitchPrimary)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.stitchSurface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                        .padding(.horizontal, 20)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(groupManager.groups) { group in
                                NavigationLink(destination: GroupDetailView(groupId: group.id)) {
                                    GroupCard(group: group)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    // 6. This Week Tracker
                    Text("This Week")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    HStack {
                        ForEach(getWeekDays(), id: \.date) { day in
                            VStack(spacing: 12) {
                                Text(day.symbol)
                                    .font(.caption2)
                                    .foregroundColor(day.isToday ? .white : Color(hex: "#A1A1A1"))
                                
                                ZStack {
                                    Circle()
                                        .stroke(day.isToday ? Color.stitchPrimary : Color.white.opacity(0.1), lineWidth: 1)
                                        .frame(width: 32, height: 32)
                                    
                                    if day.isCompleted {
                                        Circle()
                                            .fill(Color.stitchGradient)
                                            .frame(width: 32, height: 32)
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(20)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.stitchSurface)
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                        }
                    )
                    .padding(.horizontal, 20)
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
    
    struct WeekDay {
        let date: Date
        let symbol: String
        let isToday: Bool
        let isCompleted: Bool
    }
    
    private func getWeekDays() -> [WeekDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var days: [WeekDay] = []
        
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
            
            days.append(WeekDay(
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

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
    @State private var showingProfile = false
    @ObservedObject private var authManager = AuthManager.shared
    
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
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    HStack {
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
                        
                        Text("My Insights")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Color.stitchGradient)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        Image(systemName: "flame")
                            .font(.title2)
                            .foregroundStyle(Color.stitchGradient)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Chart Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Last 7 Days")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        let chartData = calculate7DayData()
                        
                        Chart {
                            ForEach(chartData) { data in
                                BarMark(
                                    x: .value("Day", data.date, unit: .day),
                                    y: .value("Completions", data.count)
                                )
                                .foregroundStyle(Color.stitchPrimary.gradient)
                                .cornerRadius(4)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { _ in
                                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .frame(height: 220)
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.stitchSurface)
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Top Metrics Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Insights")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        let bestHabit = getBestHabit()
                        
                        VStack(spacing: 16) {
                            InsightCard(title: "Best Performing Habit", value: bestHabit?.title ?? "None", icon: bestHabit?.icon ?? "star.fill", color: bestHabit != nil ? Color(hex: bestHabit!.colorHex) : .gray)
                            InsightCard(title: "Longest Single Streak", value: "\(calculateLongestStreak()) Days", icon: "flame.fill", color: .orange)
                            InsightCard(title: "Overall Completion Rate", value: "\(calculateCompletionRate())%", icon: "chart.pie.fill", color: .blue)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical)
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
        }
    }
    
    private func calculate7DayData() -> [DailyCompletion] {
        let calendar = Calendar.current
        var data: [DailyCompletion] = []
        
        let today = calendar.startOfDay(for: Date())
        
        for i in (0..<7).reversed() {
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

struct InsightCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .background(Color.stitchSurface)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(DataManager.shared)
}

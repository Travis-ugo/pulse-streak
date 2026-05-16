import SwiftUI
import SwiftData
import Charts

struct DailyCompletion: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct AnalyticsView: View {
    @Query private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Chart Section
                    Text("Last 7 Days")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    let chartData = calculate7DayData()
                    
                    Chart {
                        ForEach(chartData) { data in
                            BarMark(
                                x: .value("Day", data.date, unit: .day),
                                y: .value("Completions", data.count)
                            )
                            .foregroundStyle(Color.orange.gradient)
                            .cornerRadius(4)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        }
                    }
                    .frame(height: 220)
                    .padding()
                    .background(Color(white: 0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Top Metrics Section
                    Text("Insights")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    let bestHabit = getBestHabit()
                    
                    VStack(spacing: 16) {
                        InsightCard(title: "Best Performing Habit", value: bestHabit?.title ?? "None", icon: bestHabit?.icon ?? "star.fill", color: bestHabit != nil ? Color(hex: bestHabit!.colorHex) : .gray)
                        InsightCard(title: "Longest Single Streak", value: "\(calculateLongestStreak()) Days", icon: "flame.fill", color: .orange)
                        InsightCard(title: "Overall Completion Rate", value: "\(calculateCompletionRate())%", icon: "chart.pie.fill", color: .blue)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Analytics")
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(.dark)
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
        .background(Color(white: 0.1))
        .cornerRadius(16)
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: Habit.self, inMemory: true)
}

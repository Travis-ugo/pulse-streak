import SwiftUI

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

struct AnalyticsStatsGrid: View {
    let bestHabitTitle: String
    let bestHabitIcon: String
    let bestHabitColor: Color
    let longestStreak: Int
    let completionRate: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            VStack(spacing: 16) {
                InsightCard(title: "Best Performing Habit", value: bestHabitTitle, icon: bestHabitIcon, color: bestHabitColor)
                InsightCard(title: "Longest Single Streak", value: "\(longestStreak) Days", icon: "flame.fill", color: .orange)
                InsightCard(title: "Overall Completion Rate", value: "\(completionRate)%", icon: "chart.pie.fill", color: .blue)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AnalyticsStatsGrid(
        bestHabitTitle: "Meditate",
        bestHabitIcon: "brain.head.profile",
        bestHabitColor: .purple,
        longestStreak: 12,
        completionRate: 85
    )
    .background(Color.stitchBackground)
}

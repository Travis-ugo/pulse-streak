import SwiftUI

struct CalendarStatsHeader: View {
    let currentStreak: Int
    let longestStreak: Int
    let currentStreakStatus: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Current Streak
            VStack(alignment: .leading, spacing: 12) {
                Text("CURRENT STREAK")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#ddc1ae"))
                    .tracking(1.0)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(currentStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.stitchGradient)
                    Text("DAYS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.stitchGradient)
                }
                
                Text(currentStreakStatus)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.stitchPrimary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.stitchSurface)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
            
            // Longest Streak
            VStack(alignment: .leading, spacing: 12) {
                Text("LONGEST STREAK")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#ddc1ae"))
                    .tracking(1.0)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(longestStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("DAYS")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(longestStreak == 0 ? "No streak yet" : "Personal Best")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#A1A1A1"))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.stitchSurface)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CalendarStatsHeader(
        currentStreak: 12,
        longestStreak: 45,
        currentStreakStatus: "Active Momentum ✨"
    )
    .background(Color.stitchBackground)
}

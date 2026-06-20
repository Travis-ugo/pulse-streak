import SwiftUI

struct DashboardStreakCard: View {
    let longestStreak: Int
    let rankName: String
    let todayProgress: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(longestStreak)")
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
                ProgressRing(progress: todayProgress, color: .stitchPrimary, lineWidth: 8)
                    .frame(width: 70, height: 70)
                    .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 10)
                
                Text("\(Int(todayProgress * 100))%")
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
    }
}

#Preview {
    DashboardStreakCard(longestStreak: 25, rankName: "Gold Rank", todayProgress: 0.75)
        .background(Color.stitchBackground)
}

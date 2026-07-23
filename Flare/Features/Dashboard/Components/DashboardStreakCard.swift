import SwiftUI

struct DashboardStreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    let currentLevel: Int
    let currentXP: Int
    let rankName: String
    let todayProgress: Double
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(currentStreak)")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.stitchGradient)
                        Text("Day Streak")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.circle.fill")
                            Text(rankName)
                        }
                        .font(.caption2.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.stitchSecondary.opacity(0.2))
                        .foregroundColor(Color(hex: "#DCB8FF"))
                        .cornerRadius(8)
                        
                        Text("Best: \(longestStreak)d")
                            .font(.caption2.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.gray)
                            .cornerRadius(8)
                    }
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
            
            // Divider
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Level & XP Progress Bar
            VStack(spacing: 6) {
                HStack {
                    Text("Level \(currentLevel)")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    let nextLevelXP = 1000
                    let currentLevelProgressXP = currentXP % 1000
                    Text("\(currentLevelProgressXP) / \(nextLevelXP) XP")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Progress Track
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)
                        
                        let currentLevelProgressXP = currentXP % 1000
                        let progressFraction = Double(currentLevelProgressXP) / 1000.0
                        Capsule()
                            .fill(Color.stitchGradient)
                            .frame(width: geo.size.width * CGFloat(progressFraction), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.stitchSurface.opacity(0.85))
                .shadow(color: Color.black.opacity(0.3), radius: 15, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.15), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    DashboardStreakCard(currentStreak: 12, longestStreak: 25, currentLevel: 2, currentXP: 1450, rankName: "Silver Rank", todayProgress: 0.75)
        .background(Color.stitchBackground)
}

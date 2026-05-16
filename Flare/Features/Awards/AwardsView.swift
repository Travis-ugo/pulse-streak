import SwiftUI
import SwiftData

struct AwardsView: View {
    @Environment(\.modelContext) private var modelContext
    
    // We will use some placeholder data for the MVP layout.
    // In a real app, this would be calculated from UserStats and Habit history.
    let currentXP = 850
    let nextXP = 1000
    let unlockedCount = 12
    let peakMomentum = 142
    
    struct Badge {
        let id = UUID()
        let iconText: String?
        let iconName: String?
        let title: String
        let subtitle: String
        let isUnlocked: Bool
    }
    
    let badges = [
        Badge(iconText: "7", iconName: nil, title: "7 Day Streak", subtitle: "Ignition phase complete", isUnlocked: true),
        Badge(iconText: "30", iconName: nil, title: "30 Day Streak", subtitle: "Consistency master", isUnlocked: true),
        Badge(iconText: "90", iconName: nil, title: "90 Day Streak", subtitle: "Habit hardened", isUnlocked: true),
        Badge(iconText: "365", iconName: nil, title: "365 Day Streak", subtitle: "Locked", isUnlocked: false),
        Badge(iconText: nil, iconName: "brain.head.profile", title: "Mind Palace", subtitle: "50 Meditations", isUnlocked: false),
        Badge(iconText: nil, iconName: "dumbbell.fill", title: "Iron Will", subtitle: "200 Workouts", isUnlocked: false)
    ]
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Achievements")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Your momentum is fueling the flame.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#A1A1A1"))
                        }
                        Spacer()
                        Image(systemName: "flame")
                            .font(.title2)
                            .foregroundColor(.stitchPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Current Rank Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("CURRENT RANK")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.stitchPrimary)
                                    .tracking(1.5)
                                
                                Text("Gold\nRank")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .lineSpacing(-4)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.stitchPrimary.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "rosette")
                                    .font(.system(size: 32))
                                    .foregroundColor(.stitchPrimary)
                            }
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Next: Platinum")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                                Spacer()
                                Text("\(currentXP) / \(nextXP) XP")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.stitchPrimaryBright)
                            }
                            
                            // Custom Linear Progress Bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: "#222222"))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.stitchGradient)
                                        .frame(width: geometry.size.width * CGFloat(currentXP) / CGFloat(nextXP), height: 8)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(.top, 16)
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
                    // Left Glow Border Indicator
                    .overlay(
                        HStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.stitchGradient)
                                .frame(width: 4)
                                .padding(.vertical, 16)
                                .shadow(color: Color.stitchPrimary.opacity(0.5), radius: 8, x: 2, y: 0)
                            Spacer()
                        }
                    )
                    .padding(.horizontal, 20)
                    
                    // Milestone Badges Header
                    HStack {
                        Text("Milestone Badges")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(unlockedCount) UNLOCKED")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#DCB8FF"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.stitchSecondary.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Badges Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(badges, id: \.id) { badge in
                            BadgeCard(badge: badge)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Peak Momentum Card
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PEAK MOMENTUM")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "#ddc1ae"))
                                .tracking(1.0)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.stitchPrimary)
                                
                                Text("\(peakMomentum)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Text("Days Longest Streak")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.stitchPrimary)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 80)
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
                    .padding(.bottom, 100)
                }
                .padding(.vertical)
            }
        }
    }
}

struct BadgeCard: View {
    let badge: AwardsView.Badge
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                if badge.isUnlocked {
                    HexagonShape()
                        .fill(Color.stitchGradient)
                        .frame(width: 80, height: 90)
                        .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 10, x: 0, y: 5)
                } else {
                    HexagonShape()
                        .fill(Color(hex: "#222222").gradient)
                        .frame(width: 80, height: 90)
                        .shadow(color: .clear, radius: 10, x: 0, y: 5)
                }
                
                if let text = badge.iconText {
                    Text(text)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(badge.isUnlocked ? .black : Color(hex: "#555555"))
                } else if let icon = badge.iconName {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(badge.isUnlocked ? .black : Color(hex: "#555555"))
                }
            }
            .padding(.top, 16)
            
            VStack(spacing: 4) {
                Text(badge.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(badge.isUnlocked ? .white : Color(hex: "#888888"))
                
                HStack(spacing: 4) {
                    if !badge.isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                    }
                    Text(badge.subtitle)
                        .font(.system(size: 12))
                }
                .foregroundColor(badge.isUnlocked ? .white : Color(hex: "#888888"))
            }
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.stitchSurface)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
            }
        )
    }
}

#Preview {
    AwardsView()
}

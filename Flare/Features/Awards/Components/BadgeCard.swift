import SwiftUI

struct Badge: Identifiable {
    let id = UUID()
    let iconText: String?
    let iconName: String?
    let title: String
    let subtitle: String
    let isUnlocked: Bool
}

struct BadgeCard: View {
    let badge: Badge
    
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
    HStack(spacing: 16) {
        BadgeCard(badge: Badge(iconText: "7", iconName: nil, title: "7 Day Streak", subtitle: "Ignition phase complete", isUnlocked: true))
        BadgeCard(badge: Badge(iconText: nil, iconName: "dumbbell.fill", title: "Iron Will", subtitle: "Locked", isUnlocked: false))
    }
    .padding()
    .background(Color.stitchBackground)
}

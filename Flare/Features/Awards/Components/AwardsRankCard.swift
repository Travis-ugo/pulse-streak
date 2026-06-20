import SwiftUI

struct AwardsRankCard: View {
    let rankName: String
    let nextRankName: String
    let currentXP: Int
    let nextXP: Int
    
    var body: some View {
        let progress = nextXP > 0 ? CGFloat(currentXP) / CGFloat(nextXP) : 0
        
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CURRENT RANK")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.stitchPrimary)
                        .tracking(1.5)
                    
                    Text(rankName)
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
                    Text(nextRankName)
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
                            .frame(width: geometry.size.width * progress, height: 8)
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
    }
}

#Preview {
    AwardsRankCard(
        rankName: "Bronze\nRank",
        nextRankName: "Next: Silver",
        currentXP: 450,
        nextXP: 1000
    )
    .background(Color.stitchBackground)
}

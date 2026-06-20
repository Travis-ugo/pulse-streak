import SwiftUI

struct StreakProtectionCard: View {
    let streakFreezes: Int
    let onEquip: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("STREAK PROTECTION")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "#555555"))
                    .tracking(1.5)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "snowflake")
                        .font(.system(size: 12))
                        .foregroundColor(.stitchPrimary)
                    Text("\(streakFreezes)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.stitchSurface)
                .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Streak Freeze")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("Protects your streak if you miss a day.")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#A1A1A1"))
                }
                
                Spacer()
                
                Button(action: onEquip) {
                    Text("EQUIP")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.stitchPrimary)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.stitchSurface)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                }
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    StreakProtectionCard(streakFreezes: 2, onEquip: {})
        .background(Color.stitchBackground)
}

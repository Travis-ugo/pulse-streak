import SwiftUI

struct AwardsPeakMomentumCard: View {
    let peakMomentum: Int
    
    var body: some View {
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
}

#Preview {
    AwardsPeakMomentumCard(peakMomentum: 90)
        .background(Color.stitchBackground)
}

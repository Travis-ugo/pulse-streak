import SwiftUI

struct DashboardMetricCards: View {
    let momentumScore: Int
    let consistencyScore: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Power Score
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.stitchPrimary)
                
                Spacer(minLength: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Power Score")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#A1A1A1"))
                    Text("\(momentumScore)")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.stitchSurface)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
            
            // Consistency
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.stitchSecondary)
                
                Spacer(minLength: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Consistency")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#A1A1A1"))
                    Text(consistencyScore)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                }
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
    DashboardMetricCards(momentumScore: 85, consistencyScore: "+92%")
        .background(Color.stitchBackground)
}

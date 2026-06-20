import SwiftUI

struct ProMembershipCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Color(hex: "#FFDDB7"))
                    Text("Pro Membership")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Experience the next level with precision heat-mapping and neural analytics.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#A1A1A1"))
                    .lineSpacing(2)
                    .padding(.bottom, 8)
                
                Button(action: {}) {
                    Text("UPGRADE NOW")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .tracking(1.0)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.stitchGradient)
                        .cornerRadius(12)
                }
            }
            
            ZStack {
                Circle()
                    .fill(Color(hex: "#3A3939"))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color.stitchPrimaryBright)
            }
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#222222"))
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
            }
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProMembershipCard()
        .background(Color.stitchBackground)
}

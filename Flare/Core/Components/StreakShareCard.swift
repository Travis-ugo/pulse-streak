import SwiftUI

struct StreakShareCard: View {
    let habitName: String
    let streakCount: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            // Brand Logo
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.title3)
                    .foregroundStyle(Color.stitchGradient)
                Text("Flare")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.top, 40)
            
            Spacer()
            
            // Main Content
            VStack(spacing: 16) {
                Text("\(streakCount)")
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: color.opacity(0.6), radius: 20)
                
                Text("DAY \(habitName.uppercased()) STREAK")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
                    .tracking(2)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.stitchGradient)
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 8) {
                Text("CONSISTENCY WINS")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(3)
                
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.stitchGradient)
                    .frame(width: 40, height: 2)
            }
            .padding(.bottom, 60)
        }
        .frame(width: 400, height: 600)
        .background(
            ZStack {
                Color(hex: "#0A0A0A")
                
                // Radial Glow
                RadialGradient(
                    gradient: Gradient(colors: [color.opacity(0.15), .clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 300
                )
            }
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    StreakShareCard(habitName: "Coding", streakCount: 120, color: .orange)
}

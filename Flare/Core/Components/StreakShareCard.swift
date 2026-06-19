import SwiftUI

struct StreakShareCard: View {
    let habitName: String
    let streakCount: Int
    let color: Color
    
    var body: some View {
        ZStack {
            // Dark elegant background
            Color(hex: "#050505")
            
            // Background ambient glow matching selected color
            RadialGradient(
                gradient: Gradient(colors: [color.opacity(0.25), color.opacity(0.05), .clear]),
                center: .center,
                startRadius: 0,
                endRadius: 350
            )
            
            // Floating Glassmorphic Card
            VStack(spacing: 0) {
                // Header / Brand
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.6)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    Text("Flare")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(1.0)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Streak Number / Core Content
                VStack(spacing: 12) {
                    ZStack {
                        // Large background glowing flame behind the number
                        Image(systemName: "flame.fill")
                            .font(.system(size: 160))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [color.opacity(0.12), color.opacity(0.01)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blur(radius: 5)
                        
                        Text("\(streakCount)")
                            .font(.system(size: 110, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: color.opacity(0.6), radius: 15, x: 0, y: 5)
                    }
                    
                    VStack(spacing: 4) {
                        Text("DAY STREAK")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(color)
                            .tracking(4)
                        
                        Text(habitName.uppercased())
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .tracking(1)
                    }
                }
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("CONSISTENCY WINS")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(3)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.3)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 50, height: 3)
                }
                .padding(.bottom, 40)
            }
            .frame(width: 340, height: 540)
            .background(
                ZStack {
                    // Glass surface
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.03))
                    
                    // Glass blur effect
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                        .opacity(0.2)
                }
            )
            .overlay(
                // Gradient glowing border
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                color.opacity(0.4),
                                Color.white.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: color.opacity(0.12), radius: 25, x: 0, y: 15)
        }
        .frame(width: 400, height: 600)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    StreakShareCard(habitName: "Coding", streakCount: 120, color: .orange)
}

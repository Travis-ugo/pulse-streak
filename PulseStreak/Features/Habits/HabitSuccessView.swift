import SwiftUI

struct HabitSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    
    // An action to pass back to close the parent view (HabitCreationView)
    var onDismissComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                HStack {
                    Text("PulseStreak")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.stitchGradient)
                    
                    Spacer()
                    
                    Image(systemName: "flame")
                        .font(.title2)
                        .foregroundStyle(Color.stitchGradient)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Main Success Card
                VStack(spacing: 32) {
                    
                    // Flame Icon in Circle
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#2A1800"))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.stitchPrimary.opacity(0.3), radius: 20)
                        
                        Circle()
                            .stroke(Color.stitchPrimary.opacity(0.3), lineWidth: 1)
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "flame")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(Color.stitchGradient)
                    }
                    .padding(.top, 40)
                    
                    // Typography
                    VStack(spacing: 12) {
                        Text("Ignition\nConfirmed")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(-2)
                        
                        Text("Your new habit is live. Keep the\nfire burning.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#A1A1A1"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                    
                    // Streak Start Inner Card
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#3A2A1A"))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.stitchGradient)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Streak Start")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text("Day 1 of 30")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#A1A1A1"))
                        }
                        
                        Spacer()
                        
                        Text("01")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.stitchGradient)
                    }
                    .padding(16)
                    .background(Color(hex: "#1A1A1A"))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    
                    // Got it Button
                    Button(action: {
                        dismiss()
                        onDismissComplete()
                    }) {
                        Text("Got it")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.stitchGradient)
                            .cornerRadius(30)
                            .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 20, x: 0, y: 10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                }
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.stitchSurface)
                        
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                    }
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Bottom Indicator
                VStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Capsule()
                            .fill(Color.stitchGradient)
                            .frame(width: 24, height: 4)
                        Circle()
                            .fill(Color(hex: "#333333"))
                            .frame(width: 6, height: 6)
                        Circle()
                            .fill(Color(hex: "#333333"))
                            .frame(width: 6, height: 6)
                    }
                    
                    Text("HABIT MASTERY INITIALIZED")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#A1A1A1"))
                        .tracking(1.5)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    HabitSuccessView(onDismissComplete: {})
}

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Content based on step
                if currentStep == 0 {
                    welcomeStep
                } else if currentStep == 1 {
                    benefitsStep
                } else {
                    getStartedStep
                }
                
                Spacer()
                
                // Pagination and Next Button
                VStack(spacing: 20) {
                    HStack {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentStep == index ? Color.orange : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            if currentStep < 2 {
                                currentStep += 1
                            } else {
                                hasCompletedOnboarding = true
                            }
                        }
                    }) {
                        Text(currentStep == 2 ? "Get Started" : "Continue")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    var welcomeStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .font(.system(size: 100))
                .foregroundColor(.orange)
                .padding(.bottom, 20)
            
            Text("Welcome to\nFlare")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Build consistency and keep your momentum alive.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
        }
    }
    
    var benefitsStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 100))
                .foregroundColor(.orange)
                .padding(.bottom, 20)
            
            Text("Track Your\nProgress")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Visualize your daily achievements and build unstoppable momentum.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
        }
    }
    
    var getStartedStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 100))
                .foregroundColor(.orange)
                .padding(.bottom, 20)
            
            Text("Never Miss a\nBeat")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("We'll send you smart reminders so you never lose your streak.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnboardingView()
}

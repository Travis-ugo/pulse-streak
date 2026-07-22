import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var dataManager: DataManager
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentStep = 0
    
    // Habit Creation Data
    @State private var habitTitle = ""
    @State private var selectedIcon = "figure.strengthtraining.traditional"
    @State private var reminderTime = Date()
    @State private var dailyMotivation = true
    
    private let availableIcons = [
        ("figure.strengthtraining.traditional", "Gym"),
        ("book.fill", "Read"),
        ("figure.mind.and.body", "Meditate"),
        ("drop.fill", "Water"),
        ("chevron.left.forwardslash.chevron.right", "Code")
    ]
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                if currentStep < 4 {
                    // Skip button for intro steps
                    HStack {
                        Spacer()
                        Button("Skip") {
                            withAnimation {
                                currentStep = 4 // Go to final habit step or finish
                            }
                        }
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 10)
                }
                
                Spacer()
                
                // Screen content based on wizard step
                switch currentStep {
                case 0:
                    welcomeStep
                case 1:
                    benefitsStep
                case 2:
                    notificationStep
                case 3:
                    habitStep
                default:
                    getStartedStep
                }
                
                Spacer()
                
                // Navigation footer
                VStack(spacing: 20) {
                    HStack {
                        ForEach(0..<5) { index in
                            Circle()
                                .fill(currentStep == index ? Color.stitchPrimary : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Button(action: handleNext) {
                        Text(nextButtonText)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isNextDisabled ? Color.gray.opacity(0.3) : Color.stitchPrimary)
                            .cornerRadius(15)
                            .shadow(color: isNextDisabled ? Color.clear : Color.stitchPrimary.opacity(0.3), radius: 10)
                    }
                    .disabled(isNextDisabled)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Steps
    
    var welcomeStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .font(.system(size: 100))
                .foregroundStyle(Color.stitchGradient)
                .padding(.bottom, 20)
            
            Text("Welcome to\nFlare")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Build consistency and keep your momentum alive on your personal habits.")
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
                .foregroundColor(.stitchPrimary)
                .padding(.bottom, 20)
            
            Text("Track Your\nProgress")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Visualize your daily achievements using interactive graphs and heatmaps.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
        }
    }
    
    var notificationStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 100))
                .foregroundColor(.stitchPrimaryBright)
                .padding(.bottom, 20)
            
            Text("Never Miss a\nBeat")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Get smart reminders before your streak is at risk of breaking.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Button(action: {
                NotificationManager.shared.requestAuthorization()
            }) {
                Label("Enable Notifications", systemImage: "bell.fill")
                    .font(.subheadline.bold())
                    .foregroundColor(.stitchPrimary)
                    .padding()
                    .background(Color.stitchSurface)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.stitchPrimary.opacity(0.3), lineWidth: 1))
            }
            .padding(.top, 10)
        }
    }
    
    var habitStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create Your First Habit")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                // Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("HABIT NAME")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    TextField("", text: $habitTitle, prompt: Text("e.g. Read 10 Pages").foregroundColor(Color.white.opacity(0.3)))
                        .padding()
                        .background(Color.stitchSurface)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
                
                // Icon template picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("CATEGORY ICON")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        ForEach(availableIcons, id: \.0) { item in
                            Button(action: { selectedIcon = item.0 }) {
                                VStack(spacing: 4) {
                                    Image(systemName: item.0)
                                        .font(.title2)
                                        .foregroundColor(selectedIcon == item.0 ? .black : .white)
                                    Text(item.1)
                                        .font(.system(size: 8))
                                        .foregroundColor(selectedIcon == item.0 ? .black : .gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedIcon == item.0 ? Color.stitchPrimary : Color.stitchSurface)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                
                // Time
                VStack(alignment: .leading, spacing: 8) {
                    Text("REMINDER TIME")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    
                    DatePicker("Remind me at", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .padding()
                        .background(Color.stitchSurface)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var getStartedStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.stitchPrimary)
                .padding(.bottom, 20)
            
            Text("Ready to Build\nMomentum?")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("Your first streak is locked in. Let's keep the flame alive.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Actions
    
    private var nextButtonText: String {
        if currentStep == 3 {
            return "Save and Continue"
        } else if currentStep == 4 {
            return "Ignite My Flare"
        } else {
            return "Continue"
        }
    }
    
    private var isNextDisabled: Bool {
        currentStep == 3 && habitTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func handleNext() {
        withAnimation {
            if currentStep == 3 {
                saveFirstHabit()
                currentStep += 1
            } else if currentStep < 4 {
                currentStep += 1
            } else {
                hasCompletedOnboarding = true
            }
        }
    }
    
    private func saveFirstHabit() {
        let firstHabit = Habit(title: habitTitle, icon: selectedIcon, colorHex: "#FF8C00")
        dataManager.insert(firstHabit)
        
        if dailyMotivation {
            NotificationManager.shared.scheduleHabitReminder(id: firstHabit.id.uuidString, title: habitTitle, time: reminderTime)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(DataManager.shared)
}

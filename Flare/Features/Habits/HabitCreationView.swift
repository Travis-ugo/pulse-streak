import SwiftUI

struct HabitCreationView: View {
    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedIcon = "figure.strengthtraining.traditional"
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    @State private var reminderTime = Date()
    @State private var dailyMotivation = true
    @State private var showSuccessScreen = false
    

    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Text("New Habit")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.stitchGradient)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Image(systemName: "flame")
                        .font(.title2)
                        .foregroundStyle(Color.stitchGradient)
                }
                .padding(.top, 24)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Habit Name
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Habit Name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.stitchPrimary)
                                
                                TextField("", text: $title, prompt: Text("e.g. Morning Meditation").foregroundColor(Color.white.opacity(0.4)))
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .accentColor(.stitchPrimary)
                            }
                            .padding()
                            .background(Color(hex: "#1A1A1A"))
                            .cornerRadius(12)
                        }
                        
                        // Choose Icon
                        HabitCreationIconGrid(selectedIcon: $selectedIcon)
                        
                        // Repeat Schedule
                        HabitCreationScheduleGrid(selectedDays: $selectedDays)
                        
                        // Reminder Time & Motivation
                        HabitCreationReminderView(reminderTime: $reminderTime, dailyMotivation: $dailyMotivation)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120) // Space for floating button
                }
            }
            
            // Start My Streak Button
            VStack {
                Spacer()
                Button(action: {
                    saveHabit()
                }) {
                    Text("Start My Streak")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.stitchGradient)
                        .cornerRadius(30)
                        .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 20, x: 0, y: 10)
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $showSuccessScreen) {
            HabitSuccessView(onDismissComplete: {
                dismiss()
            })
        }
    }
    
    private func saveHabit() {
        let newHabit = Habit(title: title, icon: selectedIcon, colorHex: "#FF8C00") // Enforce Amber design
        newHabit.repeatDays = Array(selectedDays)
        dataManager.insert(newHabit)
        
        if dailyMotivation {
            NotificationManager.shared.scheduleHabitReminder(id: newHabit.id.uuidString, title: title, time: reminderTime)
        }
        
        showSuccessScreen = true
    }
}

#Preview {
    HabitCreationView()
        .environmentObject(DataManager.shared)
}

import SwiftUI
import SwiftData

struct HabitCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedIcon = "figure.strengthtraining.traditional"
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    @State private var reminderTime = Date()
    @State private var dailyMotivation = true
    @State private var showSuccessScreen = false
    
    let icons = [
        "figure.strengthtraining.traditional", "book.fill", "chevron.left.forwardslash.chevron.right", "drop.fill",
        "figure.mind.and.body", "moon.fill", "paintpalette.fill", "ellipsis"
    ]
    
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
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Choose Icon")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                                ForEach(icons, id: \.self) { icon in
                                    Button(action: {
                                        withAnimation { selectedIcon = icon }
                                    }) {
                                        ZStack {
                                            if selectedIcon == icon {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.stitchGradient)
                                                    .aspectRatio(1, contentMode: .fill)
                                            } else {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(hex: "#1A1A1A"))
                                                    .aspectRatio(1, contentMode: .fill)
                                            }
                                            
                                            Image(systemName: icon)
                                                .font(.title2)
                                                .foregroundColor(selectedIcon == icon ? .black : .white)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.stitchSurface)
                            .cornerRadius(16)
                        }
                        
                        // Repeat Schedule
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Repeat Schedule")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 0) {
                                let days = ["M", "T", "W", "T", "F", "S", "S"]
                                // Calendar representation: Sunday=1, Monday=2... Saturday=7
                                ForEach(0..<7, id: \.self) { index in
                                    let calendarDay = index == 6 ? 1 : index + 2
                                    let isSelected = selectedDays.contains(calendarDay)
                                    
                                    VStack(spacing: 8) {
                                        Text(days[index])
                                            .font(.caption)
                                            .foregroundColor(isSelected ? .stitchPrimaryBright : Color(hex: "#A1A1A1"))
                                        
                                        Button(action: {
                                            withAnimation {
                                                if isSelected {
                                                    selectedDays.remove(calendarDay)
                                                } else {
                                                    selectedDays.insert(calendarDay)
                                                }
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(isSelected ? Color.stitchPrimary : Color(hex: "#1A1A1A"))
                                                    .frame(width: 36, height: 36)
                                                
                                                if isSelected {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 12, weight: .bold))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 8)
                            .background(Color.stitchSurface)
                            .cornerRadius(16)
                        }
                        
                        // Reminder Time & Motivation
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Reminder Time")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack {
                                Spacer()
                                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                Spacer()
                            }
                            .padding(16)
                            .background(Color.stitchSurface)
                            .cornerRadius(16)
                            
                            // Daily Motivation Toggle
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Color.stitchSecondary.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(Color(hex: "#DCB8FF"))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Daily Motivation")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    Text("Receive an ember flare quote")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "#A1A1A1"))
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $dailyMotivation)
                                    .labelsHidden()
                                    .tint(.stitchPrimary)
                            }
                            .padding(16)
                            .background(Color.stitchSurface)
                            .cornerRadius(16)
                        }
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
        modelContext.insert(newHabit)
        try? modelContext.save()
        
        if dailyMotivation {
            NotificationManager.shared.scheduleHabitReminder(for: title, time: reminderTime)
        }
        
        showSuccessScreen = true
    }
}

#Preview {
    HabitCreationView()
        .modelContainer(for: Habit.self, inMemory: true)
}

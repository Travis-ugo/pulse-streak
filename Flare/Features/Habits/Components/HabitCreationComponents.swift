import SwiftUI

struct HabitCreationIconGrid: View {
    @Binding var selectedIcon: String
    let icons = [
        "figure.strengthtraining.traditional", "book.fill", "chevron.left.forwardslash.chevron.right", "drop.fill",
        "figure.mind.and.body", "moon.fill", "paintpalette.fill", "ellipsis"
    ]
    
    var body: some View {
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
    }
}

struct HabitCreationScheduleGrid: View {
    @Binding var selectedDays: Set<Int>
    
    var body: some View {
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
    }
}

struct HabitCreationReminderView: View {
    @Binding var reminderTime: Date
    @Binding var dailyMotivation: Bool
    
    var body: some View {
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
}

#Preview {
    VStack(spacing: 20) {
        HabitCreationIconGrid(selectedIcon: .constant("book.fill"))
        HabitCreationScheduleGrid(selectedDays: .constant([2, 3, 4]))
        HabitCreationReminderView(reminderTime: .constant(Date()), dailyMotivation: .constant(true))
    }
    .padding()
    .background(Color.stitchBackground)
}

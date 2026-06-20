import SwiftUI

struct CreateGroupGoalTypePicker: View {
    @Binding var taskType: GroupTaskType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Goal Type")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                ForEach(GroupTaskType.allCases, id: \.self) { type in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            taskType = type
                        }
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: type == .shared ? "person.3.sequence.fill" : "person.fill")
                                .font(.title2)
                                .foregroundColor(taskType == type ? .black : .stitchPrimary)
                            
                            Text(type.rawValue)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(taskType == type ? .black : .white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            Group {
                                if taskType == type {
                                    Color.stitchGradient
                                } else {
                                    Color.stitchSurface
                                }
                            }
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(taskType == type ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: taskType == type ? Color.stitchPrimary.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                    }
                }
            }
            
            Text(taskType == .shared ? 
                 "Shared Goal: Everyone works together to grow a single shared fire streak!" : 
                 "Individual Goals: Members keep their own personal habits, and nudge each other to complete them.")
                .font(.caption)
                .foregroundColor(.gray)
                .lineSpacing(2)
                .padding(.top, 4)
        }
    }
}

struct CreateGroupIconGrid: View {
    @Binding var selectedIcon: String
    let icons: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Icon")
                .font(.headline)
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

struct CreateGroupReminderView: View {
    @Binding var reminderTime: Date
    @Binding var dailyMotivation: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reminder Time")
                .font(.headline)
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
            
            // Group Notifications Toggle
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
                    Text("Receive a shared streak reminder")
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
        CreateGroupGoalTypePicker(taskType: .constant(.shared))
        CreateGroupIconGrid(selectedIcon: .constant("flame.fill"), icons: ["flame.fill", "book.fill"])
        CreateGroupReminderView(reminderTime: .constant(Date()), dailyMotivation: .constant(true))
    }
    .background(Color.stitchBackground)
}

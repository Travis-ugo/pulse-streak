import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    
    @State private var groupName = ""
    @State private var taskType: GroupTaskType = .shared
    @State private var sharedTaskName = ""
    @State private var inviteEmail = ""
    @State private var isLoading = false
    
    @State private var selectedIcon = "person.2.fill"
    @State private var reminderTime = Date()
    @State private var dailyMotivation = true
    
    let icons = [
        "person.2.fill", "flame.fill", "figure.strengthtraining.traditional", "book.fill",
        "figure.mind.and.body", "moon.fill", "paintpalette.fill", "ellipsis"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.stitchBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 32) {
                            // Group Details
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Group Details")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                customTextField(placeholder: "Group Name", text: $groupName, icon: "person.2")
                            }
                            
                            // Task Selection
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
                            
                            if taskType == .shared {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Shared Goal Name")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    customTextField(placeholder: "e.g. 100 Pushups", text: $sharedTaskName, icon: "target")
                                }
                            }
                            
                            // Choose Icon
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
                            
                            // Reminder Time & Motivation
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
                        .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: handleCreateGroup) {
                        if isLoading {
                            ProgressView().tint(.black)
                        } else {
                            Text("Create Group")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.stitchPrimary)
                    .cornerRadius(12)
                    .padding()
                    .disabled(isLoading || groupName.isEmpty || (taskType == .shared && sharedTaskName.isEmpty))
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.stitchPrimary)
                }
            }
        }
    }
    
    private func customTextField(placeholder: String, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            TextField("", text: text, prompt: Text(placeholder).foregroundColor(Color.white.opacity(0.4)))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.stitchSurface)
        .cornerRadius(10)
    }
    
    private func handleCreateGroup() {
        guard let user = authManager.currentUser else { return }
        isLoading = true
        
        Task {
            do {
                try await groupManager.createGroup(
                    name: groupName,
                    taskType: taskType,
                    sharedTaskName: taskType == .shared ? sharedTaskName : nil,
                    icon: selectedIcon,
                    reminderTime: reminderTime,
                    creator: user
                )
                if dailyMotivation {
                    NotificationManager.shared.scheduleHabitReminder(for: groupName, time: reminderTime)
                }
                dismiss()
            } catch {
                print("Error creating group: \(error)")
                isLoading = false
            }
        }
    }
}

#Preview {
    CreateGroupView()
}

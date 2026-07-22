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
                                
                                CustomTextField(placeholder: "Group Name", text: $groupName, icon: "person.2")
                            }
                            
                            // Task Selection
                            CreateGroupGoalTypePicker(taskType: $taskType)
                            
                            if taskType == .shared {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Shared Goal Name")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    CustomTextField(placeholder: "e.g. 100 Pushups", text: $sharedTaskName, icon: "target")
                                }
                            }
                            
                            // Choose Icon
                            CreateGroupIconGrid(selectedIcon: $selectedIcon, icons: icons)
                            
                            // Reminder Time & Motivation
                            CreateGroupReminderView(reminderTime: $reminderTime, dailyMotivation: $dailyMotivation)
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
    

    
    private func handleCreateGroup() {
        guard let user = authManager.currentUser else { return }
        isLoading = true
        
        Task {
            do {
                let groupId = try await groupManager.createGroup(
                    name: groupName,
                    taskType: taskType,
                    sharedTaskName: taskType == .shared ? sharedTaskName : nil,
                    icon: selectedIcon,
                    reminderTime: reminderTime,
                    creator: user
                )
                if dailyMotivation {
                    NotificationManager.shared.scheduleHabitReminder(id: groupId, title: groupName, time: reminderTime)
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

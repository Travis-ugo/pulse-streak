import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var groupManager = GroupManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var groupName = ""
    @State private var taskType: GroupTaskType = .shared
    @State private var sharedTaskName = ""
    @State private var inviteEmail = ""
    @State private var isLoading = false
    
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
                                
                                Picker("Goal Type", selection: $taskType) {
                                    ForEach(GroupTaskType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .colorMultiply(.stitchPrimary)
                                
                                Text(taskType == .shared ? 
                                     "Everyone works towards a single group goal." : 
                                     "Everyone works towards their own personal habit.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
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
            TextField(placeholder, text: text)
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
                    creator: user
                )
                dismiss()
            } catch {
                print("Error creating group: \(error)")
                isLoading = false
            }
        }
    }
}

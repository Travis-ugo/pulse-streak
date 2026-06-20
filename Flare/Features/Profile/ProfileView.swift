import SwiftUI
import PhotosUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject private var dataManager: DataManager
    @ObservedObject private var authManager = AuthManager.shared
    
    @AppStorage("appleHealthEnabled") private var appleHealthEnabled = true
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isUploading = false
    @State private var showingAvatarPreview = false
    
    private var profileUIImage: UIImage? {
        guard let photoURL = authManager.currentUser?.photoURL else { return nil }
        return loadImageFromBase64(photoURL)
    }
    
    private func loadImageFromBase64(_ base64String: String) -> UIImage? {
        let cleanString: String
        if base64String.hasPrefix("data:image") {
            let components = base64String.components(separatedBy: ",")
            if components.count > 1 {
                cleanString = components[1]
            } else {
                return nil
            }
        } else {
            cleanString = base64String
        }
        
        guard let data = Data(base64Encoded: cleanString) else { return nil }
        return UIImage(data: data)
    }
    
    private var joinedDateString: String {
        let date = authManager.currentUser?.joinedAt ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date).uppercased()
    }
    
    private var completionsCount: Int {
        dataManager.habits.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var currentXP: Int {
        completionsCount * 50
    }
    
    private var currentLevel: Int {
        (currentXP / 1000) + 1
    }
    
    private var rankName: String {
        let level = currentLevel
        if level >= 10 { return "DIAMOND" }
        if level >= 7 { return "PLATINUM" }
        if level >= 5 { return "GOLD" }
        if level >= 3 { return "SILVER" }
        return "BRONZE"
    }
    
    private func addFreeze() {
        dataManager.userStats.streakFreezes += 1
        dataManager.saveUserStats()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Header
                    HStack {
                        Text("Flare")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "flame")
                            .font(.title2)
                            .foregroundStyle(Color.stitchGradient)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Profile Card
                    ProfileHeaderCard(
                        profileUIImage: profileUIImage,
                        joinedDateString: joinedDateString,
                        rankName: rankName,
                        currentLevel: currentLevel,
                        showingAvatarPreview: $showingAvatarPreview,
                        isUploading: $isUploading,
                        selectedItem: $selectedItem
                    )
                    
                    // Streak Freeze Section
                    StreakProtectionCard(
                        streakFreezes: dataManager.userStats.streakFreezes,
                        onEquip: addFreeze
                    )
                    
                    // Pro Membership Card
                    ProMembershipCard()
                    
                    // Preferences
                    PreferencesGroup()
                    
                    // Logout
                    Button(action: {
                        authManager.signOut()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("SECURE LOGOUT")
                                .tracking(1.5)
                        }
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#FFB4AB"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(hex: "#161111"))
                        .cornerRadius(30)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(hex: "#331111"), lineWidth: 1))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingAvatarPreview) {
            AvatarPreviewView(profileUIImage: profileUIImage, selectedItem: $selectedItem, isUploading: $isUploading)
        }
    }
}
}

#Preview {
    let _ = {
        AuthManager.shared.currentUser = User(
            id: "preview-user-id",
            email: "preview@example.com",
            displayName: "Jane Doe",
            joinedAt: Date()
        )
        AuthManager.shared.isLoading = false
    }()
    
    return ProfileView()
        .environmentObject(DataManager.shared)
}

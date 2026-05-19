import SwiftUI
import SwiftData
import PhotosUI
import FirebaseFirestore

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userStats: [UserStats]
    @ObservedObject private var authManager = AuthManager.shared
    
    @Query private var habits: [Habit]
    
    @AppStorage("appleHealthEnabled") private var appleHealthEnabled = true
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isUploading = false
    
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
        habits.flatMap { $0.completionHistory ?? [] }.count
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
        if let stats = userStats.first {
            stats.streakFreezes += 1
        } else {
            let newStats = UserStats(streakFreezes: 1)
            modelContext.insert(newStats)
        }
        try? modelContext.save()
    }
    
    var body: some View {
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
                    VStack(spacing: 16) {
                        // Avatar selection
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            ZStack {
                                Circle()
                                    .stroke(Color.stitchPrimary, lineWidth: 2)
                                    .frame(width: 88, height: 88)
                                    .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 10)
                                
                                if let uiImage = profileUIImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(Color(hex: "#222222"))
                                        .background(Circle().fill(Color.stitchSurface))
                                }
                                
                                if isUploading {
                                    Color.black.opacity(0.6)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color.stitchPrimary)
                                            .frame(width: 26, height: 26)
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .offset(x: 28, y: 28)
                                }
                            }
                        }
                        .disabled(isUploading)
                        .padding(.top, 24)
                        .onChange(of: selectedItem) { _, newItem in
                            guard let newItem = newItem else { return }
                            isUploading = true
                            Task {
                                do {
                                    if let data = try? await newItem.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        // Downscale to 180x180 to guarantee Firestore performance and document limits
                                        let size = CGSize(width: 180, height: 180)
                                        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
                                        uiImage.draw(in: CGRect(origin: .zero, size: size))
                                        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                                        UIGraphicsEndImageContext()
                                        
                                        if let finalImage = scaledImage,
                                           let jpegData = finalImage.jpegData(compressionQuality: 0.5) {
                                            let base64String = jpegData.base64EncodedString()
                                            let dataURL = "data:image/jpeg;base64,\(base64String)"
                                            try await authManager.updateProfilePhoto(to: dataURL)
                                        }
                                    }
                                } catch {
                                    print("Error processing selected image: \(error)")
                                }
                                isUploading = false
                            }
                        }
                        
                        VStack(spacing: 4) {
                            Text(authManager.currentUser?.displayName ?? authManager.currentUser?.email ?? "Guest User")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("EXPLORER • \(joinedDateString)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#A1A1A1"))
                                .tracking(1.5)
                        }
                        
                        HStack(spacing: 12) {
                            Text("\(rankName) RANK")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.stitchPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#3A2000"))
                                .cornerRadius(12)
                            
                            Text("LEVEL \(currentLevel)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#DCB8FF"))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#301B4D"))
                                .cornerRadius(12)
                        }
                        .padding(.bottom, 24)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.stitchSurface)
                            
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                        }
                    )
                    .padding(.horizontal, 20)
                    
                    // Streak Freeze Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("STREAK PROTECTION")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#555555"))
                                .tracking(1.5)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "snowflake")
                                    .font(.system(size: 12))
                                    .foregroundColor(.stitchPrimary)
                                Text("\(userStats.first?.streakFreezes ?? 0)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.stitchSurface)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Streak Freeze")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Protects your streak if you miss a day.")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                            }
                            
                            Spacer()
                            
                            Button(action: addFreeze) {
                                Text("EQUIP")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.stitchPrimary)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.stitchSurface)
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Pro Membership Card
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(Color(hex: "#FFDDB7"))
                                Text("Pro Membership")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Experience the next level with precision heat-mapping and neural analytics.")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#A1A1A1"))
                                .lineSpacing(2)
                                .padding(.bottom, 8)
                            
                            Button(action: {}) {
                                Text("UPGRADE NOW")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.black)
                                    .tracking(1.0)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.stitchGradient)
                                    .cornerRadius(12)
                            }
                        }
                        
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#3A3939"))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.stitchPrimaryBright)
                        }
                    }
                    .padding(20)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "#222222"))
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                        }
                    )
                    .padding(.horizontal, 20)
                    
                    // Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PREFERENCES")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#555555"))
                            .tracking(1.5)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            // Notifications
                            PreferenceRow(icon: "bell", title: "Notifications") {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#555555"))
                            }
                            
                            Divider().background(Color.white.opacity(0.05)).padding(.leading, 64)
                            
                            // Visual Theme
                            VStack(alignment: .leading, spacing: 16) {
                                PreferenceRow(icon: "paintpalette", title: "Visual Theme") { EmptyView() }
                                    .padding(.bottom, -16)
                                
                                HStack(spacing: 24) {
                                    ThemeSwatch(name: "EMBER", color: Color.stitchPrimary, isSelected: selectedTheme == "EMBER")
                                        .onTapGesture { selectedTheme = "EMBER" }
                                    ThemeSwatch(name: "SKY", color: Color(hex: "#2B4673"), isSelected: selectedTheme == "SKY")
                                        .onTapGesture { selectedTheme = "SKY" }
                                    ThemeSwatch(name: "NEON", color: Color(hex: "#480081"), isSelected: selectedTheme == "NEON")
                                        .onTapGesture { selectedTheme = "NEON" }
                                }
                                .padding(.leading, 64)
                                .padding(.bottom, 20)
                            }
                            
                            Divider().background(Color.white.opacity(0.05)).padding(.leading, 64)
                            
                            // Apple Health
                            PreferenceRow(icon: "heart", title: "Apple Health") {
                                Toggle("", isOn: $appleHealthEnabled)
                                    .labelsHidden()
                                    .tint(Color.stitchPrimary)
                            }
                            
                            Divider().background(Color.white.opacity(0.05)).padding(.leading, 64)
                            
                            // Cloud Backup
                            PreferenceRow(icon: "cloud", title: "Cloud Backup", subtitle: authManager.currentUser != nil ? "SYNCED TO CLOUD" : "LOCAL ONLY") {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#555555"))
                            }
                        }
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.stitchSurface)
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                    
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
    }
}

struct PreferenceRow<Content: View>: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let trailingContent: () -> Content
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#1A1A1A"))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color.stitchPrimaryBright)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#555555"))
                }
            }
            
            Spacer()
            
            trailingContent()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

struct ThemeSwatch: View {
    let name: String
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if isSelected {
                    Circle()
                        .stroke(Color.stitchPrimary, lineWidth: 2)
                        .frame(width: 48, height: 48)
                }
                
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
            }
            
            Text(name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(isSelected ? Color.stitchPrimary : Color(hex: "#555555"))
        }
    }
}

#Preview {
    ProfileView()
}

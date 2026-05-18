import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userStats: [UserStats]
    
    @State private var appleHealthEnabled = true
    @State private var selectedTheme = "EMBER"
    
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
                        // Avatar
                        ZStack {
                            Circle()
                                .stroke(Color.stitchPrimary, lineWidth: 2)
                                .frame(width: 88, height: 88)
                                .shadow(color: Color.stitchPrimary.opacity(0.4), radius: 10)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(hex: "#222222"))
                                .background(Circle().fill(Color.stitchSurface))
                        }
                        .padding(.top, 24)
                        
                        VStack(spacing: 4) {
                            Text("Alex Sterling")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("EXPLORER • OCT 2023")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#A1A1A1"))
                                .tracking(1.5)
                        }
                        
                        HStack(spacing: 12) {
                            Text("PRO")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.stitchPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#3A2000"))
                                .cornerRadius(12)
                            
                            Text("LEVEL 4")
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
                            PreferenceRow(icon: "cloud", title: "Cloud Backup", subtitle: "SYNCED 2M AGO") {
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
                    Button(action: {}) {
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

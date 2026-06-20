import SwiftUI

struct PreferencesGroup: View {
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @AppStorage("appleHealthEnabled") private var appleHealthEnabled = true
    @ObservedObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("PREFERENCES")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(hex: "#555555"))
                .tracking(1.5)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                // Notifications
                NavigationLink(destination: NotificationSettingsView()) {
                    PreferenceRow(icon: "bell", title: "Notifications") {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#555555"))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider().background(Color.white.opacity(0.05)).padding(.leading, 64)
                
                // Visual Theme
                VStack(alignment: .leading, spacing: 16) {
                    PreferenceRow(icon: "paintpalette", title: "Visual Theme") { EmptyView() }
                        .padding(.bottom, -16)
                    HStack(spacing: 24) {
                        ThemeSwatch(name: "EMBER", color: Color.stitchPrimary, isSelected: selectedTheme == "EMBER")
                            .onTapGesture {
                                selectedTheme = "EMBER"
                                UserDefaults.standard.synchronize()
                            }
                        ThemeSwatch(name: "SKY", color: Color(hex: "#2B4673"), isSelected: selectedTheme == "SKY")
                            .onTapGesture {
                                selectedTheme = "SKY"
                                UserDefaults.standard.synchronize()
                            }
                        ThemeSwatch(name: "NEON", color: Color(hex: "#480081"), isSelected: selectedTheme == "NEON")
                            .onTapGesture {
                                selectedTheme = "NEON"
                                UserDefaults.standard.synchronize()
                            }
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
    }
}

#Preview {
    NavigationView {
        PreferencesGroup()
            .background(Color.stitchBackground)
    }
}

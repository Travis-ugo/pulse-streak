import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @AppStorage("dailyRemindersEnabled") private var dailyRemindersEnabled = true
    @AppStorage("streakDangerEnabled") private var streakDangerEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 24) {
                // Header navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Profile")
                        }
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(.stitchPrimaryBright)
                    }
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible balancing element
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Profile")
                    }
                    .font(.headline)
                    .foregroundColor(.clear)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Intro text
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Alert Settings")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Manage reminder times and danger alerts to keep your streaks alive.")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#A1A1A1"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Settings Group
                        VStack(spacing: 0) {
                            // Daily reminders
                            NotificationToggleRow(
                                icon: "bell.badge.fill",
                                title: "Daily Reminders",
                                subtitle: "Reminds you to check in daily",
                                isOn: $dailyRemindersEnabled
                            )
                            
                            Divider().background(Color.white.opacity(0.05)).padding(.leading, 64)
                            
                            // Streak danger
                            NotificationToggleRow(
                                icon: "exclamationmark.triangle.fill",
                                title: "Streak Danger Alerts",
                                subtitle: "Alert when streak is close to breaking",
                                isOn: $streakDangerEnabled
                            )
                            
                            Divider().background(Color.white.opacity(0.05)).padding(.leading, 64)
                            
                            // Sounds
                            NotificationToggleRow(
                                icon: "speaker.wave.3.fill",
                                title: "Notification Sounds",
                                subtitle: "Play standard alerts sound",
                                isOn: $soundEnabled
                            )
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
                        
                        // Info Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.stitchPrimary)
                                Text("Pro Tip")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            
                            Text("Consistency is key. Users with Daily Reminders enabled are 85% more likely to keep their streaks active past 30 days!")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#A1A1A1"))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.02))
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct NotificationToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
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
                
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#777777"))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.stitchPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

#Preview {
    NotificationSettingsView()
}

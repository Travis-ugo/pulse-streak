import SwiftUI

struct CalendarView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject private var dataManager: DataManager
    private var habits: [Habit] { dataManager.habits }
    
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @State private var showingProfile = false
    @ObservedObject private var authManager = AuthManager.shared
    
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
    
    private var totalHabitsCrushed: Int {
        habits.flatMap { $0.completionHistory ?? [] }.count
    }
    
    private var currentStreak: Int {
        habits.map { $0.streakCount }.max() ?? 0
    }
    
    private var longestStreak: Int {
        habits.map { $0.longestStreak }.max() ?? 0
    }
    
    private var currentStreakStatus: String {
        if currentStreak == 0 {
            return "Start your streak!"
        } else if currentStreak >= 30 {
            return "Elite Status 🔥"
        } else if currentStreak >= 15 {
            return "Unstoppable ⚡️"
        } else if currentStreak >= 7 {
            return "Consistency Master 🌟"
        } else if currentStreak >= 3 {
            return "Active Momentum ✨"
        } else {
            return "Keep the flame alive!"
        }
    }
    
    private var initiateState: TimelineState {
        if longestStreak >= 7 {
            return longestStreak < 100 ? .active : .past
        } else {
            return .locked
        }
    }
    
    private var centurionState: TimelineState {
        if longestStreak >= 100 {
            return longestStreak < 365 ? .active : .past
        } else {
            return .locked
        }
    }
    
    private var masterState: TimelineState {
        if longestStreak >= 365 {
            return .active
        } else {
            return .locked
        }
    }
    
    private var initiateDate: String {
        longestStreak >= 7 ? "ACHIEVED" : "\(longestStreak)/7 DAYS"
    }
    
    private var centurionDate: String {
        longestStreak >= 100 ? "ACHIEVED" : "\(longestStreak)/100 DAYS"
    }
    
    private var masterDate: String {
        longestStreak >= 365 ? "ACHIEVED" : "\(longestStreak)/365 DAYS"
    }
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    HStack {
                        Button(action: {
                            showingProfile = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.stitchSurface)
                                    .frame(width: 36, height: 36)
                                
                                if let uiImage = profileUIImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 36, height: 36)
                                        .clipShape(Circle())
                                } else {
                                    Text(authManager.currentUser?.initials ?? "U")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.stitchPrimaryBright)
                                }
                            }
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                        }
                        
                        Text("My Journey")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Color.stitchGradient)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        Image(systemName: "flame")
                            .font(.title2)
                            .foregroundStyle(Color.stitchGradient)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Pulse Matrix
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Pulse Matrix")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("\(totalHabitsCrushed) Habits Crushed this year")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                            }
                            
                            Spacer()
                            
                            // Legend
                            HStack(spacing: 4) {
                                Text("LESS")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                                    .padding(.trailing, 2)
                                
                                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#222222")).frame(width: 8, height: 8)
                                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#563622")).frame(width: 8, height: 8)
                                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#8a5a3a")).frame(width: 8, height: 8)
                                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#d89155")).frame(width: 8, height: 8)
                                RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#ffddb7")).frame(width: 8, height: 8)
                                
                                Text("MORE")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color(hex: "#A1A1A1"))
                                    .padding(.leading, 2)
                            }
                            .padding(.top, 6)
                        }
                        
                        HeatmapView(habits: habits)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.stitchSurface)
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                }
                            )
                    }
                    .padding(.horizontal, 20)
                    
                    // Streak Cards
                    HStack(spacing: 16) {
                        // Current Streak
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CURRENT STREAK")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "#ddc1ae"))
                                .tracking(1.0)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(currentStreak)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.stitchGradient)
                                Text("DAYS")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color.stitchGradient)
                            }
                            
                            Text(currentStreakStatus)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.stitchPrimary)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.stitchSurface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                        
                        // Longest Streak
                        VStack(alignment: .leading, spacing: 12) {
                            Text("LONGEST STREAK")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "#ddc1ae"))
                                .tracking(1.0)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("\(longestStreak)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("DAYS")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text(longestStreak == 0 ? "No streak yet" : "Personal Best")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#A1A1A1"))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.stitchSurface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
                    }
                    .padding(.horizontal, 20)
                    
                    // Streak Journey
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Streak Journey")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "rosette")
                                .font(.title2)
                                .foregroundColor(.stitchPrimary)
                        }
                        .padding(.horizontal, 20)
                        
                        // Timeline
                        VStack(spacing: 0) {
                            TimelineNode(
                                title: "EMBER INITIATE",
                                date: initiateDate,
                                description: "Reached a 7-day perfect streak. The internal fire is starting to catch.",
                                pills: ["MINDSET": Color.stitchSecondary, "CONSISTENCY": Color(hex: "#5C3A15")],
                                state: initiateState
                            )
                            
                            TimelineNode(
                                title: "STREAK CENTURION",
                                date: centurionDate,
                                description: "Maintained momentum for 100 consecutive days of focused action.",
                                pills: [:],
                                state: centurionState
                            )
                            
                            TimelineNode(
                                title: "PULSE MASTER",
                                date: masterDate,
                                description: "Complete 365 days of streaks to reach ultimate mastery.",
                                pills: [:],
                                state: masterState
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
        }
    }
}

enum TimelineState {
    case active, past, locked
}

struct TimelineNode: View {
    let title: String
    let date: String
    let description: String
    let pills: [String: Color]
    let state: TimelineState
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline line and dot
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 16, height: 16)
                        .shadow(color: state == .active ? Color.stitchPrimary.opacity(0.6) : .clear, radius: 8)
                    
                    if state == .active {
                        Circle()
                            .fill(Color.stitchGradient)
                            .frame(width: 16, height: 16)
                    }
                }
                
                if state != .locked {
                    Rectangle()
                        .fill(lineColor)
                        .frame(width: 2)
                        .frame(height: 160) // Fixed height to simulate continuous line
                }
            }
            .padding(.top, 24)
            
            // Content Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(titleColor)
                        .tracking(1.0)
                    Spacer()
                    Text(date)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#A1A1A1"))
                }
                
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(descColor)
                    .lineSpacing(4)
                
                if !pills.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(Array(pills.keys.sorted().reversed()), id: \.self) { key in
                            Text(key)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(pills[key] == Color.stitchSecondary ? Color(hex: "#DCB8FF") : .stitchPrimary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(pills[key]?.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
                
                if state == .past {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.stitchGradient)
                        .frame(height: 4)
                        .padding(.top, 8)
                }
            }
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(state == .locked ? Color(hex: "#1A1A1A") : Color.stitchSurface)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                }
            )
            .overlay(
                HStack {
                    if state == .active {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.stitchGradient)
                            .frame(width: 2)
                            .padding(.vertical, 16)
                    }
                    Spacer()
                }
            )
            .padding(.bottom, state == .locked ? 0 : 36)
        }
    }
    
    // Styling helpers
    private var dotColor: Color {
        switch state {
        case .active: return Color.stitchPrimary
        case .past: return Color(hex: "#8a5a3a")
        case .locked: return Color(hex: "#222222")
        }
    }
    
    private var lineColor: Color {
        switch state {
        case .active: return Color(hex: "#8a5a3a")
        case .past: return Color(hex: "#222222")
        case .locked: return .clear
        }
    }
    
    private var titleColor: Color {
        switch state {
        case .active: return .stitchPrimaryBright
        case .past: return .white
        case .locked: return Color(hex: "#A1A1A1")
        }
    }
    
    private var descColor: Color {
        switch state {
        case .active, .past: return .white
        case .locked: return Color(hex: "#555555")
        }
    }
}

#Preview {
    CalendarView(selectedTab: .constant(1))
        .environmentObject(DataManager.shared)
}

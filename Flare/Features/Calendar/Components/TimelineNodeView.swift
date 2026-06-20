import SwiftUI

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
    ScrollView {
        VStack {
            TimelineNode(
                title: "EMBER INITIATE",
                date: "ACHIEVED",
                description: "Reached a 7-day perfect streak. The internal fire is starting to catch.",
                pills: ["MINDSET": Color.stitchSecondary, "CONSISTENCY": Color(hex: "#5C3A15")],
                state: .past
            )
            TimelineNode(
                title: "STREAK CENTURION",
                date: "14/100 DAYS",
                description: "Maintained momentum for 100 consecutive days of focused action.",
                pills: [:],
                state: .active
            )
            TimelineNode(
                title: "PULSE MASTER",
                date: "14/365 DAYS",
                description: "Complete 365 days of streaks to reach ultimate mastery.",
                pills: [:],
                state: .locked
            )
        }
        .padding()
        .background(Color.stitchBackground)
    }
}

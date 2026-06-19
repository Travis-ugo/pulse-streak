import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // MARK: - Stitch Theme Colors
    static let stitchBackground = Color(hex: "#0A0A0A")
    static let stitchSurface = Color(hex: "#161616")
    
    static var stitchPrimary: Color {
        let theme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "EMBER"
        switch theme {
        case "SKY":
            return Color(hex: "#007AFF") // Sky Blue
        case "NEON":
            return Color(hex: "#FF007F") // Neon Pink
        default:
            return Color(hex: "#FF8C00") // Ember Orange
        }
    }
    
    static var stitchPrimaryBright: Color {
        let theme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "EMBER"
        switch theme {
        case "SKY":
            return Color(hex: "#64D2FF") // Sky Light Blue
        case "NEON":
            return Color(hex: "#BF5AF2") // Neon Purple
        default:
            return Color(hex: "#FFA500") // Bright Ember
        }
    }
    
    static var stitchSecondary: Color {
        let theme = UserDefaults.standard.string(forKey: "selectedTheme") ?? "EMBER"
        switch theme {
        case "SKY":
            return Color(hex: "#5856D6") // Indigo
        case "NEON":
            return Color(hex: "#00F0FF") // Cyan
        default:
            return Color(hex: "#8A2BE2") // Purple
        }
    }
    
    static var stitchGradient: LinearGradient {
        LinearGradient(colors: [stitchPrimary, stitchPrimaryBright], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

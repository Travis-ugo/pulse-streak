import SwiftUI

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
    HStack(spacing: 24) {
        ThemeSwatch(name: "EMBER", color: Color.stitchPrimary, isSelected: true)
        ThemeSwatch(name: "SKY", color: Color(hex: "#2B4673"), isSelected: false)
    }
    .background(Color.stitchBackground)
}

import SwiftUI

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

#Preview {
    VStack {
        PreferenceRow(icon: "bell", title: "Notifications", subtitle: "ON") {
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        PreferenceRow(icon: "heart", title: "Apple Health") {
            Toggle("", isOn: .constant(true)).labelsHidden()
        }
    }
    .background(Color.stitchBackground)
}

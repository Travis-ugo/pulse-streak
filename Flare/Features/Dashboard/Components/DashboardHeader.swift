import SwiftUI

struct DashboardHeader: View {
    let profileUIImage: UIImage?
    let initials: String
    let onProfileTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onProfileTap) {
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
                        Text(initials)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.stitchPrimaryBright)
                    }
                }
                .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 0.5))
            }
            
            Spacer()
            
            Image(systemName: "flame")
                .foregroundColor(.stitchPrimary)
                .font(.title3)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

#Preview {
    DashboardHeader(profileUIImage: nil, initials: "TD", onProfileTap: {})
        .background(Color.stitchBackground)
}

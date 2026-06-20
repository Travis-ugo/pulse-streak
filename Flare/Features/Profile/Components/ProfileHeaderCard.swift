import SwiftUI
import PhotosUI

struct ProfileHeaderCard: View {
    let profileUIImage: UIImage?
    let joinedDateString: String
    let rankName: String
    let currentLevel: Int
    @Binding var showingAvatarPreview: Bool
    @Binding var isUploading: Bool
    @Binding var selectedItem: PhotosPickerItem?
    
    @ObservedObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Avatar preview button
            Button(action: {
                showingAvatarPreview = true
            }) {
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
            .onChange(of: selectedItem) { newItem in
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
    }
}

#Preview {
    ProfileHeaderCard(
        profileUIImage: nil,
        joinedDateString: "JUN 2026",
        rankName: "BRONZE",
        currentLevel: 1,
        showingAvatarPreview: .constant(false),
        isUploading: .constant(false),
        selectedItem: .constant(nil)
    )
    .background(Color.stitchBackground)
}

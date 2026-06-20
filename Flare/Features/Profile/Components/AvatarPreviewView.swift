import SwiftUI
import PhotosUI

struct AvatarPreviewView: View {
    let profileUIImage: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var isUploading: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Full dark screen
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top controls bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Profile Photo")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible spacer for visual balance
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundColor(.clear)
                }
                .padding()
                
                Spacer()
                
                // Photo container
                if let uiImage = profileUIImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(hex: "#222222"))
                        .frame(width: 250, height: 250)
                }
                
                Spacer()
                
                // Action row
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Change Photo")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.stitchPrimary)
                    .cornerRadius(24)
                    .shadow(color: Color.stitchPrimary.opacity(0.3), radius: 10)
                }
                .padding(.bottom, 40)
            }
        }
        .onChange(of: selectedItem) { _ in
            // Dismiss preview once photo is chosen and starts uploading
            dismiss()
        }
    }
}

#Preview {
    AvatarPreviewView(
        profileUIImage: nil,
        selectedItem: .constant(nil),
        isUploading: .constant(false)
    )
}

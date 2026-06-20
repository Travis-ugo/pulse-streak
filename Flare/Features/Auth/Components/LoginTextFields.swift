import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.white.opacity(0.4)))
                .textInputAutocapitalization(.none)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.stitchSurface)
        .cornerRadius(10)
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.white.opacity(0.4)))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.stitchSurface)
        .cornerRadius(10)
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomTextField(placeholder: "Email", text: .constant(""), icon: "envelope")
        CustomSecureField(placeholder: "Password", text: .constant(""), icon: "lock")
    }
    .padding()
    .background(Color.stitchBackground)
}

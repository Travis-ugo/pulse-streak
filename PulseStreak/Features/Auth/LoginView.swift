import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var error: String?
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.stitchBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                // Logo/Header
                VStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.stitchGradient)
                    
                    Text("PulseStreak")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(isSignUp ? "Create your account" : "Welcome back")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                // Inputs
                VStack(spacing: 16) {
                    customTextField(placeholder: "Email", text: $email, icon: "envelope")
                    customSecureField(placeholder: "Password", text: $password, icon: "lock")
                }
                .padding(.horizontal)
                
                if let error = error {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Action Button
                Button(action: handleAuth) {
                    if isLoading {
                        ProgressView()
                            .tint(.black)
                    } else {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.stitchPrimary)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                
                // Toggle Login/SignUp
                Button(action: { isSignUp.toggle() }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.stitchPrimary)
                }
            }
            .padding()
        }
    }
    
    private func customTextField(placeholder: String, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.none)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.stitchSurface)
        .cornerRadius(10)
    }
    
    private func customSecureField(placeholder: String, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            SecureField(placeholder, text: text)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.stitchSurface)
        .cornerRadius(10)
    }
    
    private func handleAuth() {
        isLoading = true
        error = nil
        
        if isSignUp {
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                isLoading = false
                if let err = err {
                    error = err.localizedDescription
                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, err in
                isLoading = false
                if let err = err {
                    error = err.localizedDescription
                }
            }
        }
    }
}

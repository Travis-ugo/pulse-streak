import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var name = ""
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
                    
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(isSignUp ? "Ignite your daily streaks and build habits today" : "Welcome back! Continue growing your ember streaks")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                // Inputs
                VStack(spacing: 16) {
                    if isSignUp {
                        CustomTextField(placeholder: "Name", text: $name, icon: "person")
                    }
                    CustomTextField(placeholder: "Email", text: $email, icon: "envelope")
                    CustomSecureField(placeholder: "Password", text: $password, icon: "lock")
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
                .disabled(isLoading || email.isEmpty || password.isEmpty || (isSignUp && name.isEmpty))
                
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    Text("OR").font(.caption2).foregroundColor(.gray)
                    Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)
                
                Button(action: handleGoogleSignIn) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                        Text("Continue with Google")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(isLoading)
                
                // Toggle Login/SignUp
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                            .foregroundColor(Color(hex: "#A1A1A1"))
                        Text(isSignUp ? "Sign In" : "Sign Up")
                            .font(.system(.footnote, weight: .bold))
                            .foregroundColor(.stitchPrimaryBright)
                    }
                    .font(.footnote)
                }
            }
            .padding()
        }
    }
    
    private func handleAuth() {
        isLoading = true
        error = nil
        
        if isSignUp {
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    isLoading = false
                    error = AuthErrorHelper.getFriendlyErrorMessage(err.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    isLoading = false
                    return
                }
                
                // Write user profile to Firestore immediately to avoid race conditions
                let db = Firestore.firestore()
                let newUser = User(
                    id: user.uid,
                    email: email,
                    displayName: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? (email.components(separatedBy: "@").first ?? "") : name,
                    joinedAt: Date()
                )
                
                do {
                    try db.collection("users").document(user.uid).setData(from: newUser)
                } catch {
                    print("Error saving user to Firestore: \(error)")
                }
                
                // Also update FirebaseAuth display name
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? (email.components(separatedBy: "@").first ?? "") : name
                changeRequest.commitChanges { _ in
                    isLoading = false
                }
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, err in
                isLoading = false
                if let err = err {
                    error = AuthErrorHelper.getFriendlyErrorMessage(err.localizedDescription)
                }
            }
        }
    }
    
    private func handleGoogleSignIn() {
        isLoading = true
        error = nil
        
        Task {
            do {
                try await GoogleAuthService.shared.signInWithGoogle()
                isLoading = false
            } catch {
                self.error = AuthErrorHelper.getFriendlyErrorMessage(error.localizedDescription)
                isLoading = false
            }
        }
    }
}

#Preview {
    LoginView()
}

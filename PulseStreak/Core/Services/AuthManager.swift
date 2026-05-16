import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var currentUser: User?
    @Published var isLoading = true
    
    private var authListener: AuthStateDidChangeListenerHandle?
    @Published var userCache: [String: User] = [:]
    private let db = Firestore.firestore()
    
    private init() {
        listenToAuthState()
    }
    
    func fetchUser(by id: String) async -> User? {
        if let cached = userCache[id] { return cached }
        
        do {
            let snapshot = try await db.collection("users").document(id).getDocument()
            if let user = try? snapshot.data(as: User.self) {
                userCache[id] = user
                return user
            }
        } catch {
            print("Error fetching user \(id): \(error)")
        }
        return nil
    }
    
    func listenToAuthState() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }
            
            if let firebaseUser = firebaseUser {
                Task {
                    await self.fetchUserData(uid: firebaseUser.uid, email: firebaseUser.email ?? "")
                }
            } else {
                self.currentUser = nil
                self.isLoading = false
            }
        }
    }
    
    private func fetchUserData(uid: String, email: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            
            if snapshot.exists {
                self.currentUser = try snapshot.data(as: User.self)
            } else {
                // Create new user profile if it doesn't exist
                let newUser = User(
                    id: uid,
                    email: email,
                    displayName: email.components(separatedBy: "@").first,
                    joinedAt: Date()
                )
                try db.collection("users").document(uid).setData(from: newUser)
                self.currentUser = newUser
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
        self.isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

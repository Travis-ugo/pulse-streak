import Foundation
import Combine
#if canImport(FirebaseAuth)
import FirebaseAuth
#endif
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

#if !canImport(FirebaseFirestore)
// Minimal placeholder to allow compilation when FirebaseFirestore isn't linked.
// Replace with real Firestore usage by adding the Firebase SDK to the project.
struct FirestorePlaceholder {}
#endif

#if !canImport(FirebaseAuth)
// Provide minimal shims so the file compiles without FirebaseAuth.
// These are no-ops and will not perform authentication.
final class Auth {
    static func auth() -> Auth { Auth() }
    func addStateDidChangeListener(_ listener: @escaping (Auth, Any?) -> Void) -> AnyObject? { return nil }
    func signOut() throws {}
}

typealias AuthStateDidChangeListenerHandle = AnyObject
#endif

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var currentUser: User?
    @Published var isLoading = true
    
    private var authListener: AuthStateDidChangeListenerHandle?
    @Published var userCache: [String: User] = [:]
#if canImport(FirebaseFirestore)
    private let db = Firestore.firestore()
#else
    // Placeholder to avoid compile errors when FirebaseFirestore is not available
    private let db: Any? = nil
#endif
    
    private init() {
        listenToAuthState()
    }
    
    func fetchUser(by id: String) async -> User? {
        if let cached = userCache[id] { return cached }
#if !canImport(FirebaseFirestore)
        return nil
#endif
        
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
#if canImport(FirebaseAuth)
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }
            if let firebaseUser = firebaseUser {
                #if canImport(FirebaseAuth)
                let uid = firebaseUser.uid
                let email = firebaseUser.email ?? ""
                #else
                let uid = ""
                let email = ""
                #endif
                Task<Void, Never> {
                    await self.fetchUserData(uid: uid, email: email)
                }
            } else {
                self.currentUser = nil
                self.isLoading = false
            }
        }
#else
        // FirebaseAuth not available; no auth state to observe.
        self.currentUser = nil
        self.isLoading = false
#endif
    }
    
    private func fetchUserData(uid: String, email: String) async {
#if !canImport(FirebaseFirestore)
        // Without Firestore, we can't fetch or create user records.
        self.currentUser = nil
        self.isLoading = false
        return
#endif
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
#if canImport(FirebaseAuth)
            try Auth.auth().signOut()
#else
            // No-op when FirebaseAuth is unavailable
#endif
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

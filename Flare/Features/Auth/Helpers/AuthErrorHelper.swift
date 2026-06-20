import Foundation

struct AuthErrorHelper {
    static func getFriendlyErrorMessage(_ errorMessage: String) -> String {
        let lowercased = errorMessage.lowercased()
        if lowercased.contains("keychain") {
            return "Secure Storage Lock: The iOS Simulator's secure store is locked. Please try again or restart the simulator."
        }
        if lowercased.contains("email address is badly formatted") || lowercased.contains("invalid-email") || lowercased.contains("invalid email") {
            return "Please enter a valid email address."
        }
        if lowercased.contains("email address is already in use") || lowercased.contains("email-already-in-use") {
            return "This email is already registered. Try signing in instead!"
        }
        if lowercased.contains("password must be") || lowercased.contains("weak-password") || lowercased.contains("password is invalid") {
            return "Password must be at least 6 characters long."
        }
        if lowercased.contains("no user record") || lowercased.contains("invalid-credential") || lowercased.contains("wrong-password") || lowercased.contains("wrong password") {
            return "Incorrect email or password. Please try again."
        }
        if lowercased.contains("network") || lowercased.contains("connection lost") {
            return "Network connection issue. Please check your internet connection."
        }
        return errorMessage
    }
}

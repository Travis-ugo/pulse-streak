import SwiftUI
import FirebaseCore

@main
struct FlareApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DataManager.shared)
        }
    }
}

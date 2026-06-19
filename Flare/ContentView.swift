import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataManager: DataManager
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedTheme") private var selectedTheme = "EMBER"
    @ObservedObject private var authManager = AuthManager.shared
    @State private var selectedTab = 0

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.stitchBackground)
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        if authManager.isLoading {
            ZStack {
                Color.stitchBackground.edgesIgnoringSafeArea(.all)
                ProgressView()
                    .tint(Color.stitchPrimary)
            }
        } else if !hasCompletedOnboarding {
            OnboardingView()
        } else if authManager.currentUser == nil {
            LoginView()
        } else {
            TabView(selection: $selectedTab) {
                NavigationView {
                    DashboardView(habits: dataManager.habits, selectedTab: $selectedTab)
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
                NavigationView {
                    CalendarView(selectedTab: $selectedTab)
                }
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
                
                AnalyticsView()
                    .tabItem {
                        Label("Analytics", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(2)
                
                AwardsView()
                    .tabItem {
                        Label("Awards", systemImage: "rosette")
                    }
                    .tag(3)
            }
            .preferredColorScheme(.dark)
            .tint(Color.stitchPrimary)
            .onAppear {
                NotificationManager.shared.requestAuthorization()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager.shared)
}

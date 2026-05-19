//
//  ContentView.swift
//  Flare
//
//  Created by Travis Okonicha on 07/05/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
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
        if !hasCompletedOnboarding {
            OnboardingView()
        } else if authManager.currentUser == nil {
            LoginView()
        } else {
            TabView(selection: $selectedTab) {
                NavigationView {
                    DashboardView(habits: habits, selectedTab: $selectedTab)
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
        .modelContainer(for: Habit.self, inMemory: true)
}

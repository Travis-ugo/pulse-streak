//
//  ContentView.swift
//  PulseStreak
//
//  Created by Travis Okonicha on 07/05/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

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
        } else {
            TabView {
                DashboardView(habits: habits)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                
                AnalyticsView()
                    .tabItem {
                        Label("Analytics", systemImage: "chart.line.uptrend.xyaxis")
                    }
                
                AwardsView()
                    .tabItem {
                        Label("Awards", systemImage: "rosette")
                    }
                
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .preferredColorScheme(.dark)
            .tint(Color.stitchPrimary)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}

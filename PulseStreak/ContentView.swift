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
    
    @State private var showingAddHabit = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingView()
        } else {
            TabView {
                NavigationStack {
                    DashboardView(habits: habits)
                        .navigationTitle("PulseStreak 🔥")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: { showingAddHabit = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                }
                            }
                        }
                        .sheet(isPresented: $showingAddHabit) {
                            HabitCreationView()
                        }
                }
                .tabItem {
                    Label("Home", systemImage: "flame.fill")
                }
                
                Text("Calendar View")
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                
                Text("Stats View")
                    .tabItem {
                        Label("Analytics", systemImage: "chart.bar.fill")
                    }
            }
            .preferredColorScheme(.dark)
            .tint(.orange)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}

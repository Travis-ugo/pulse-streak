import SwiftUI
import SwiftData

struct DashboardView: View {
    var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Good Evening, Travis 🔥")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundColor(.white)
                        Text("Momentum Maintained")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    // Momentum Score Badge
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Text("84")
                            .font(.system(.headline, design: .rounded, weight: .heavy))
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
                
                // Habits Section
                Text("Today's Habits")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                if habits.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "flame")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No habits yet")
                            .font(.headline)
                        Text("Tap the + button to build your momentum.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(habits) { habit in
                            HabitCardView(habit: habit)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    DashboardView(habits: [])
        .modelContainer(for: Habit.self, inMemory: true)
}

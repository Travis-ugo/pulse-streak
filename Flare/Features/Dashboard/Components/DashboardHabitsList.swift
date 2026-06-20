import SwiftUI

struct DashboardHabitsList: View {
    let habits: [Habit]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Habits")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Spacer()
                Text("View All")
                    .font(.caption)
                    .foregroundColor(.stitchPrimaryBright)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if habits.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "flame")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No habits yet")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Tap the + button to build your momentum.")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#A1A1A1"))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(habits) { habit in
                        EmberCardView(habit: habit)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    DashboardHabitsList(habits: [])
        .background(Color.stitchBackground)
}

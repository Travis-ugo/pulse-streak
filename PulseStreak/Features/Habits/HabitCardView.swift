import SwiftUI
import SwiftData
struct HabitCardView: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    @State private var isCompletedToday: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: habit.colorHex).opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: habit.icon)
                    .font(.title2)
                    .foregroundColor(Color(hex: habit.colorHex))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundColor(habit.streakCount > 0 ? .orange : .gray)
                    Text("\(habit.streakCount) day streak")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Complete Button
            Button(action: {
                toggleCompletion()
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(isCompletedToday ? Color.orange : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 32, height: 32)
                    
                    if isCompletedToday {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding()
        .background(Color(white: 0.1))
        .cornerRadius(20)
        .onAppear {
            checkCompletionStatus()
        }
    }
    
    private func toggleCompletion() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isCompletedToday.toggle()
            if isCompletedToday {
                habit.streakCount += 1
                if habit.streakCount > habit.longestStreak {
                    habit.longestStreak = habit.streakCount
                }
                let completion = Completion(completedAt: Date(), status: "completed")
                if habit.completionHistory == nil {
                    habit.completionHistory = []
                }
                habit.completionHistory?.append(completion)
                modelContext.insert(completion)
                
                // Trigger Haptic Feedback
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            } else {
                habit.streakCount = max(0, habit.streakCount - 1)
                // Remove completion for today (simplified for MVP)
            }
            try? modelContext.save()
        }
    }
    
    private func checkCompletionStatus() {
        // Basic check: did they complete it today?
        guard let history = habit.completionHistory else { return }
        let calendar = Calendar.current
        let todayCompletions = history.filter { calendar.isDateInToday($0.completedAt) }
        isCompletedToday = !todayCompletions.isEmpty
    }
}

#Preview {
    HabitCardView(habit: Habit(title: "Read 10 Pages", icon: "book.fill", colorHex: "#32ADE6"))
        .modelContainer(for: Habit.self, inMemory: true)
}


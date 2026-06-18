import SwiftUI
struct HabitCardView: View {
    let habit: Habit
    @State private var isCompletedToday: Bool = false
    @State private var showingShareSheet: Bool = false
    
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
        .contextMenu {
            Button(action: {
                showingShareSheet = true
            }) {
                Label("Share Streak", systemImage: "square.and.arrow.up")
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            StreakSharePreviewView(
                habitName: habit.title,
                streakCount: habit.streakCount,
                initialColorHex: habit.colorHex
            )
        }
        .onAppear {
            checkCompletionStatus()
        }
    }
    
    private func toggleCompletion() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            StreakManager.shared.toggleCompletion(for: habit)
            isCompletedToday = StreakManager.shared.isCompletedToday(habit: habit)
        }
    }
    
    private func checkCompletionStatus() {
        isCompletedToday = StreakManager.shared.isCompletedToday(habit: habit)
    }
}

#Preview {
    HabitCardView(habit: Habit(title: "Read 10 Pages", icon: "book.fill", colorHex: "#32ADE6"))
        .environmentObject(DataManager.shared)
}


import SwiftUI

struct EmberCardView: View {
    @EnvironmentObject private var dataManager: DataManager
    let habit: Habit
    @State private var isCompletedToday: Bool = false
    @State private var showingShareSheet: Bool = false
    @State private var showingDeleteConfirmation: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Left Glow Border Indicator
            if isCompletedToday {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.stitchGradient)
                    .frame(width: 4)
                    .padding(.vertical, 12)
                    .shadow(color: Color.stitchPrimary.opacity(0.5), radius: 8, x: 2, y: 0)
            } else {
                Spacer().frame(width: 4)
            }
            
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: habit.colorHex).opacity(0.15))
                    .frame(width: 48, height: 48)
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
                    if isNearBreak && !isCompletedToday {
                        FlickeringFlame(color: .red)
                            .font(.caption)
                        Text("\(habit.streakCount) day streak")
                            .font(.caption.bold())
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundColor(habit.streakCount > 0 ? Color.stitchPrimary : Color.gray)
                        Text("\(habit.streakCount) day streak")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#A1A1A1"))
                    }
                }
            }
            
            Spacer()
            
            // Complete Toggle
            Button(action: {
                toggleCompletion()
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(isCompletedToday ? Color.stitchPrimary : Color.gray.opacity(0.2), lineWidth: 2)
                        .frame(width: 32, height: 32)
                    
                    if isCompletedToday {
                        Circle()
                            .fill(Color.stitchGradient)
                            .frame(width: 32, height: 32)
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.vertical, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.stitchSurface)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            }
        )
        .cornerRadius(16)
        .contextMenu {
            Button(action: {
                showingShareSheet = true
            }) {
                Label("Share Streak", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive) {
                showingDeleteConfirmation = true
            } label: {
                Label("Delete Habit", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            StreakSharePreviewView(
                habitName: habit.title,
                streakCount: habit.streakCount,
                initialColorHex: habit.colorHex
            )
        }
        .alert("Delete Habit", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    dataManager.delete(habit)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete '\(habit.title)'? This will permanently erase your streak history for this habit.")
        }
        .onAppear {
            checkCompletionStatus()
        }
    }
    
    private func toggleCompletion() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            StreakManager.shared.toggleCompletion(for: habit)
            isCompletedToday = StreakManager.shared.isCompletedToday(habit: habit)
        }
    }
    
    private func checkCompletionStatus() {
        isCompletedToday = StreakManager.shared.isCompletedToday(habit: habit)
    }
    
    private var isNearBreak: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        // Consider "Near Break" if it's past 8 PM and not done
        return hour >= 20
    }
}

#Preview {
    EmberCardView(habit: Habit(title: "Preview", icon: "flame", colorHex: "#FF8C00"))
        .environmentObject(DataManager.shared)
}

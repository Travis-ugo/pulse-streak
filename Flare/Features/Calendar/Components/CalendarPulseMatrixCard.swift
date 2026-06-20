import SwiftUI

struct CalendarPulseMatrixCard: View {
    let totalHabitsCrushed: Int
    let habits: [Habit]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pulse Matrix")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("\(totalHabitsCrushed) Habits Crushed this year")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#A1A1A1"))
                }
                
                Spacer()
                
                // Legend
                HStack(spacing: 4) {
                    Text("LESS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color(hex: "#A1A1A1"))
                        .padding(.trailing, 2)
                    
                    RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#222222")).frame(width: 8, height: 8)
                    RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#563622")).frame(width: 8, height: 8)
                    RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#8a5a3a")).frame(width: 8, height: 8)
                    RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#d89155")).frame(width: 8, height: 8)
                    RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#ffddb7")).frame(width: 8, height: 8)
                    
                    Text("MORE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color(hex: "#A1A1A1"))
                        .padding(.leading, 2)
                }
                .padding(.top, 6)
            }
            
            HeatmapView(habits: habits)
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.stitchSurface)
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    }
                )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CalendarPulseMatrixCard(totalHabitsCrushed: 15, habits: [])
        .background(Color.stitchBackground)
}

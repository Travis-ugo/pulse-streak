import SwiftUI
import SwiftData

struct HeatmapView: View {
    var habits: [Habit]
    
    // Grid settings
    let columns = 14 // 14 weeks = 98 days
    let rows = 7 // Sunday - Saturday
    let spacing: CGFloat = 4
    
    var body: some View {
        let (dates, intensities) = calculateHeatmap()
        let today = Calendar.current.startOfDay(for: Date())
        
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: spacing) {
                ForEach(0..<columns, id: \.self) { col in
                    VStack(spacing: spacing) {
                        ForEach(0..<rows, id: \.self) { row in
                            let index = col * rows + row
                            if index < dates.count {
                                let date = dates[index]
                                let intensity = intensities[date] ?? 0
                                
                                HeatmapCell(intensity: intensity, isFuture: date > today)
                            } else {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.clear)
                                    .frame(width: 14, height: 14)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func calculateHeatmap() -> ([Date], [Date: Int]) {
        let calendar = Calendar.current
        var dates: [Date] = []
        var intensities: [Date: Int] = [:]
        
        let today = calendar.startOfDay(for: Date())
        let currentWeekday = calendar.component(.weekday, from: today) // 1 = Sun, 7 = Sat
        
        // Find how many days until Saturday (7) so the last column aligns correctly
        let daysToSaturday = 7 - currentWeekday
        guard let endDate = calendar.date(byAdding: .day, value: daysToSaturday, to: today) else { return ([], [:]) }
        
        // Go back (columns * 7) days
        let totalDays = columns * rows
        guard let startDate = calendar.date(byAdding: .day, value: -totalDays + 1, to: endDate) else { return ([], [:]) }
        
        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            intensities[currentDate] = 0
            if let next = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = next
            } else {
                break
            }
        }
        
        // Populate intensities
        for habit in habits {
            if let history = habit.completionHistory {
                for completion in history {
                    let date = calendar.startOfDay(for: completion.completedAt)
                    if intensities[date] != nil {
                        intensities[date]! += 1
                    }
                }
            }
        }
        

        
        return (dates, intensities)
    }
}

struct HeatmapCell: View {
    let intensity: Int
    let isFuture: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(colorForIntensity(intensity))
            .frame(width: 14, height: 14)
            .shadow(color: glowColorForIntensity(intensity), radius: intensity >= 3 ? 4 : 0)
            .opacity(isFuture ? 0.05 : 1.0)
    }
    
    private func colorForIntensity(_ count: Int) -> Color {
        if count == 0 {
            return Color(hex: "#222222")
        } else if count == 1 {
            return Color(hex: "#563622")
        } else if count == 2 {
            return Color(hex: "#8a5a3a")
        } else if count == 3 {
            return Color(hex: "#d89155")
        } else {
            return Color(hex: "#ffddb7")
        }
    }
    
    private func glowColorForIntensity(_ count: Int) -> Color {
        if count >= 3 {
            return Color(hex: "#FF8C00").opacity(0.4)
        }
        return .clear
    }
}

#Preview {
    HeatmapView(habits: [])
}

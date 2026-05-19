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
        
        HStack(alignment: .top, spacing: 8) {
            // Weekday labels
            VStack(spacing: spacing) {
                Text("").frame(height: 14) // Sun
                Text("M").frame(height: 14) // Mon
                Text("").frame(height: 14) // Tue
                Text("W").frame(height: 14) // Wed
                Text("").frame(height: 14) // Thu
                Text("F").frame(height: 14) // Fri
                Text("").frame(height: 14) // Sat
            }
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(Color(hex: "#666666"))
            .padding(.top, 16) // Align with month header (12 height + 4 spacing)
            
            VStack(alignment: .leading, spacing: 4) {
                // Month headers
                HStack(spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { col in
                        let monthLabel = getMonthLabel(for: col, dates: dates)
                        Text(monthLabel)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(hex: "#888888"))
                            .frame(width: 14, alignment: .leading)
                    }
                }
                .frame(height: 12)
                
                // Heatmap cells
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
    }
    
    private func getMonthLabel(for col: Int, dates: [Date]) -> String {
        guard col * rows < dates.count else { return "" }
        let calendar = Calendar.current
        let date = dates[col * rows]
        
        if col == 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return formatter.string(from: date)
        }
        
        let prevDate = dates[(col - 1) * rows]
        let currentMonth = calendar.component(.month, from: date)
        let prevMonth = calendar.component(.month, from: prevDate)
        
        if currentMonth != prevMonth {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            return formatter.string(from: date)
        }
        
        return ""
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

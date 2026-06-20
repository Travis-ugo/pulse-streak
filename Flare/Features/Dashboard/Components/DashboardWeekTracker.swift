import SwiftUI

struct DashboardWeekTracker: View {
    struct WeekDay: Identifiable {
        var id: Date { date }
        let date: Date
        let symbol: String
        let isToday: Bool
        let isCompleted: Bool
    }
    
    let weekDays: [WeekDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            HStack {
                ForEach(weekDays) { day in
                    VStack(spacing: 12) {
                        Text(day.symbol)
                            .font(.caption2)
                            .foregroundColor(day.isToday ? .white : Color(hex: "#A1A1A1"))
                        
                        ZStack {
                            Circle()
                                .stroke(day.isToday ? Color.stitchPrimary : Color.white.opacity(0.1), lineWidth: 1)
                                .frame(width: 32, height: 32)
                            
                            if day.isCompleted {
                                Circle()
                                    .fill(Color.stitchGradient)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.stitchSurface)
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                }
            )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    DashboardWeekTracker(weekDays: [
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "M", isToday: false, isCompleted: true),
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "T", isToday: false, isCompleted: true),
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "W", isToday: false, isCompleted: false),
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "T", isToday: true, isCompleted: true),
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "F", isToday: false, isCompleted: false),
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "S", isToday: false, isCompleted: false),
        DashboardWeekTracker.WeekDay(date: Date(), symbol: "S", isToday: false, isCompleted: false)
    ])
    .background(Color.stitchBackground)
}

import SwiftUI
import WidgetKit
import ActivityKit

struct HabitLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HabitAttributes.self) { context in
            // Lock screen / Banner UI
            VStack(spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.16, green: 0.09, blue: 0.0))
                            .frame(width: 44, height: 44)
                        Image(systemName: "flame")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(context.attributes.streakCount) Day Streak")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0)) // Orange
                        Text("PulseStreak Live Activity")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.7))
                    }
                    
                    Spacer()
                    
                    Text("\(Int(context.state.progressPercentage * 100))%")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(white: 0.2))
                            .frame(height: 12)
                        
                        Capsule()
                            .fill(LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(geometry.size.width * CGFloat(context.state.progressPercentage), 0), height: 12)
                            .shadow(color: Color.orange.opacity(0.5), radius: 5)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    Text(context.attributes.habitTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.0))
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.0))
                        Image(systemName: "stopwatch").foregroundColor(Color(white: 0.4))
                    }
                }
            }
            .padding(20)
            .background(Color(white: 0.1))
            .cornerRadius(24)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "flame").foregroundColor(.orange)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(Int(context.state.progressPercentage * 100))%").foregroundColor(.orange)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.attributes.streakCount) Day Streak")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: context.state.progressPercentage)
                        .tint(.orange)
                }
            } compactLeading: {
                Image(systemName: "flame").foregroundColor(.orange)
            } compactTrailing: {
                Text("\(Int(context.state.progressPercentage * 100))%")
            } minimal: {
                Image(systemName: "flame").foregroundColor(.orange)
            }
        }
    }
}

#Preview("Live Activity", as: .content, using: HabitAttributes(habitTitle: "Morning Run", streakCount: 5)) {
   HabitLiveActivity()
} contentStates: {
    HabitAttributes.ContentState(progressPercentage: 0.5, remainingTime: "5:00")
}

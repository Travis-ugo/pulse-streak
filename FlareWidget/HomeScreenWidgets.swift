import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let sharedDefaults = UserDefaults(suiteName: "group.com.flare.streak")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            isNearBreak: false,
            streakCount: 12,
            consistencyPercentage: 82,
            momentumScore: 148,
            weeklyProgress: [1.0, 0.8, 1.0, 0.5, 1.0, 0.3, 0.0],
            heatmapData: Array(repeating: 0, count: 48),
            totalDaysWithCompletions: 148
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = getEntry(for: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = getEntry(for: currentDate)
        
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    private func getEntry(for date: Date) -> SimpleEntry {
        let hour = Calendar.current.component(.hour, from: date)
        let isNearBreak = hour >= 20
        
        let defaults = sharedDefaults
        let streak = defaults?.integer(forKey: "streakCount") ?? 0
        let consistency = defaults?.integer(forKey: "consistencyPercentage") ?? 0
        let momentum = defaults?.integer(forKey: "momentumScore") ?? 0
        let weekly = defaults?.array(forKey: "weeklyProgress") as? [Double] ?? [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let heatmap = defaults?.array(forKey: "heatmapData") as? [Int] ?? Array(repeating: 0, count: 48)
        let totalDays = defaults?.integer(forKey: "totalDaysWithCompletions") ?? 0
        
        return SimpleEntry(
            date: date,
            isNearBreak: isNearBreak,
            streakCount: streak,
            consistencyPercentage: consistency,
            momentumScore: momentum,
            weeklyProgress: weekly,
            heatmapData: heatmap,
            totalDaysWithCompletions: totalDays
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isNearBreak: Bool
    
    // Live Stats
    let streakCount: Int
    let consistencyPercentage: Int
    let momentumScore: Int
    let weeklyProgress: [Double]
    let heatmapData: [Int]
    let totalDaysWithCompletions: Int
}

struct HomeScreenWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            if entry.isNearBreak {
                Color(red: 0.2, green: 0.05, blue: 0.05) // Urgent dark red background
            } else {
                Color(red: 0.1, green: 0.1, blue: 0.1)
            }
            
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            case .systemLarge:
                LargeWidgetView(entry: entry)
            default:
                Text("Unsupported")
            }
        }
    }
}

struct SmallWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(entry.isNearBreak ? Color.red.opacity(0.2) : Color(red: 0.16, green: 0.09, blue: 0.0))
                        .frame(width: 24, height: 24)
                    Image(systemName: entry.isNearBreak ? "flame.fill" : "flame")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(entry.isNearBreak ? .red : Color.orange)
                        .offset(x: entry.isNearBreak ? 1 : 0) // Static "shake" offset
                }
                
                Spacer()
                
                if entry.isNearBreak {
                    Text("BREAKING")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(4)
                } else {
                    Text("\(entry.consistencyPercentage)%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(entry.streakCount)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("DAY STREAK")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(white: 0.7))
                    .tracking(1.5)
            }
        }
        .padding(16)
    }
}

struct MediumWidgetView: View {
    let entry: SimpleEntry
    let days = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.2)) // Brownish dot
                    .frame(width: 8, height: 8)
                
                Text("Weekly Momentum")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Power: \(entry.momentumScore)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.7)) // Pale orange/peach
            }
            
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(0..<7, id: \.self) { i in
                    VStack(spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .bottom) {
                                Capsule()
                                    .fill(Color(white: 0.2))
                                
                                Capsule()
                                    .fill(Color(red: 1.0, green: 0.6, blue: 0.2)) // Peach/Orange
                                    .frame(height: geo.size.height * CGFloat(entry.weeklyProgress[safe: i] ?? 0.0))
                            }
                        }
                        .frame(width: 14, height: 40)
                        
                        Text(days[i])
                            .font(.system(size: 10))
                            .foregroundColor(Color(white: 0.6))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            HStack(spacing: 8) {
                // Task icons (yellow, orange, purple)
                ZStack {
                    Circle().fill(Color.orange).frame(width: 20, height: 20)
                    Image(systemName: "figure.mind.and.body").font(.system(size: 10)).foregroundColor(.black)
                }
                ZStack {
                    Circle().fill(Color.yellow).frame(width: 20, height: 20)
                    Image(systemName: "dumbbell.fill").font(.system(size: 10)).foregroundColor(.black)
                }
                ZStack {
                    Circle().fill(Color.purple).frame(width: 20, height: 20)
                    Image(systemName: "book.fill").font(.system(size: 10)).foregroundColor(.black)
                }
                
                Spacer()
                
                Text("\(entry.consistencyPercentage)% Consistency")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
            }
        }
        .padding(16)
    }
}

struct LargeWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pulse Matrix")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("Intensity over 4 weeks")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.7))
                }
                
                Spacer()
                
                Text("ELITE LEVEL")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.2, green: 0.1, blue: 0.0))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.3, green: 0.15, blue: 0.0), lineWidth: 1))
            }
            
            // Heatmap
            HStack(alignment: .top, spacing: 4) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mon").font(.system(size: 8)).foregroundColor(Color(white: 0.5)).frame(height: 12)
                    Text("Wed").font(.system(size: 8)).foregroundColor(Color(white: 0.5)).frame(height: 12)
                    Text("Fri").font(.system(size: 8)).foregroundColor(Color(white: 0.5)).frame(height: 12)
                }
                .padding(.top, 4)
                
                VStack(spacing: 4) {
                    // The heatmap shows 4 rows of boxes.
                    ForEach(0..<4, id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<12, id: \.self) { col in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(getColor(row: row, col: col))
                                    .frame(width: 14, height: 14)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            HStack(alignment: .bottom, spacing: 24) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(entry.totalDaysWithCompletions)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("TOTAL DAYS")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(white: 0.6))
                        .tracking(1.0)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(entry.consistencyPercentage)%")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("CONSISTENCY")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(white: 0.6))
                        .tracking(1.0)
                }
            }
        }
        .padding(20)
    }
    
    // Helper to generate heatmap colors based on live heatmapData
    func getColor(row: Int, col: Int) -> Color {
        let index = row * 12 + col
        guard index < entry.heatmapData.count else { return Color(white: 0.15) }
        let value = entry.heatmapData[index]
        
        let orange = Color(red: 1.0, green: 0.55, blue: 0.0)
        let darkOrange = Color(red: 0.8, green: 0.4, blue: 0.0)
        let empty = Color(white: 0.2)
        
        switch value {
        case 2:
            return orange // All completed
        case 1:
            return darkOrange // Some completed
        default:
            return empty // None completed
        }
    }
}

struct HomeScreenWidgets: Widget {
    let kind: String = "HomeScreenWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeScreenWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Flare")
        .description("Keep the fire burning with daily stats.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// Safe array accessor
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview("Small Widget", as: .systemSmall) {
    HomeScreenWidgets()
} timeline: {
    SimpleEntry(
        date: .now,
        isNearBreak: false,
        streakCount: 12,
        consistencyPercentage: 82,
        momentumScore: 148,
        weeklyProgress: [1.0, 0.8, 1.0, 0.5, 1.0, 0.3, 0.0],
        heatmapData: Array(repeating: 0, count: 48),
        totalDaysWithCompletions: 148
    )
}

#Preview("Medium Widget", as: .systemMedium) {
    HomeScreenWidgets()
} timeline: {
    SimpleEntry(
        date: .now,
        isNearBreak: false,
        streakCount: 12,
        consistencyPercentage: 82,
        momentumScore: 148,
        weeklyProgress: [1.0, 0.8, 1.0, 0.5, 1.0, 0.3, 0.0],
        heatmapData: Array(repeating: 0, count: 48),
        totalDaysWithCompletions: 148
    )
}

#Preview("Large Widget", as: .systemLarge) {
    HomeScreenWidgets()
} timeline: {
    SimpleEntry(
        date: .now,
        isNearBreak: false,
        streakCount: 12,
        consistencyPercentage: 82,
        momentumScore: 148,
        weeklyProgress: [1.0, 0.8, 1.0, 0.5, 1.0, 0.3, 0.0],
        heatmapData: Array(repeating: 0, count: 48),
        totalDaysWithCompletions: 148
    )
}

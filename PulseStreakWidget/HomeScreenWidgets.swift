import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [SimpleEntry(date: Date())]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct HomeScreenWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1) // Dark background like the mockup
            
            switch family {
            case .systemSmall:
                SmallWidgetView()
            case .systemMedium:
                MediumWidgetView()
            case .systemLarge:
                LargeWidgetView()
            default:
                Text("Unsupported")
            }
        }
    }
}

struct SmallWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.16, green: 0.09, blue: 0.0))
                        .frame(width: 24, height: 24)
                    Image(systemName: "flame")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.orange)
                }
                
                Spacer()
                
                Text("82%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                Text("12")
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
    let days = ["M", "T", "W", "T", "F", "S", "S"]
    let progress: [CGFloat] = [1.0, 0.8, 1.0, 0.5, 1.0, 0.3, 0.0] // Example data matching mockup
    
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
                
                Text("Next: Meditation")
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
                                    .frame(height: geo.size.height * progress[i])
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
                
                Text("+3 Tasks Left")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.55, blue: 0.0))
            }
        }
        .padding(16)
    }
}

struct LargeWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pulse Matrix")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("Intensity over 12 weeks")
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
                    // The mockup shows 4 rows of boxes.
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
                    Text("148")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("TOTAL DAYS")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(white: 0.6))
                        .tracking(1.0)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("94%")
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
    
    // Helper to generate mockup-like heatmap colors
    func getColor(row: Int, col: Int) -> Color {
        let orange = Color(red: 1.0, green: 0.55, blue: 0.0)
        let darkOrange = Color(red: 0.8, green: 0.4, blue: 0.0)
        let empty = Color(white: 0.2)
        let darkEmpty = Color(white: 0.15)
        
        let val = (row * 3 + col * 7) % 10
        if val > 6 { return orange }
        if val > 4 { return darkOrange }
        if val > 2 { return darkEmpty }
        return empty
    }
}

struct HomeScreenWidgets: Widget {
    let kind: String = "HomeScreenWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeScreenWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("PulseStreak")
        .description("Keep the fire burning with daily stats.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview("Small Widget", as: .systemSmall) {
    HomeScreenWidgets()
} timeline: {
    SimpleEntry(date: .now)
}

#Preview("Medium Widget", as: .systemMedium) {
    HomeScreenWidgets()
} timeline: {
    SimpleEntry(date: .now)
}

#Preview("Large Widget", as: .systemLarge) {
    HomeScreenWidgets()
} timeline: {
    SimpleEntry(date: .now)
}

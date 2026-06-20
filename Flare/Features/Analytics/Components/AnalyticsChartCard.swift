import SwiftUI
import Charts

struct AnalyticsChartCard: View {
    @Binding var selectedRange: Int
    let chartData: [DailyCompletion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedRange == 0 ? "Last 7 Days" : "Last 30 Days")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Picker("Range", selection: $selectedRange) {
                    Text("Weekly").tag(0)
                    Text("Monthly").tag(1)
                }
                .pickerStyle(.segmented)
                .frame(width: 140)
            }
            .padding(.horizontal, 20)
            
            Chart {
                ForEach(chartData) { data in
                    BarMark(
                        x: .value("Day", data.date, unit: .day),
                        y: .value("Completions", data.count)
                    )
                    .foregroundStyle(Color.stitchPrimary.gradient)
                    .cornerRadius(selectedRange == 0 ? 4 : 2)
                }
            }
            .chartXAxis {
                if selectedRange == 0 {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            .foregroundStyle(Color.gray)
                    }
                } else {
                    AxisMarks(values: .stride(by: .day, count: 5)) { _ in
                        AxisValueLabel(format: .dateTime.day())
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .frame(height: 220)
            .padding()
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
    AnalyticsChartCard(selectedRange: .constant(0), chartData: [])
        .background(Color.stitchBackground)
}

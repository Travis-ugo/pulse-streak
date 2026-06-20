import SwiftUI

struct CalendarJourneyTimeline: View {
    let initiateDate: String
    let centurionDate: String
    let masterDate: String
    let initiateState: TimelineState
    let centurionState: TimelineState
    let masterState: TimelineState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Streak Journey")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "rosette")
                    .font(.title2)
                    .foregroundColor(.stitchPrimary)
            }
            .padding(.horizontal, 20)
            
            // Timeline Nodes list
            VStack(spacing: 0) {
                TimelineNode(
                    title: "EMBER INITIATE",
                    date: initiateDate,
                    description: "Reached a 7-day perfect streak. The internal fire is starting to catch.",
                    pills: ["MINDSET": Color.stitchSecondary, "CONSISTENCY": Color(hex: "#5C3A15")],
                    state: initiateState
                )
                
                TimelineNode(
                    title: "STREAK CENTURION",
                    date: centurionDate,
                    description: "Maintained momentum for 100 consecutive days of focused action.",
                    pills: [:],
                    state: centurionState
                )
                
                TimelineNode(
                    title: "PULSE MASTER",
                    date: masterDate,
                    description: "Complete 365 days of streaks to reach ultimate mastery.",
                    pills: [:],
                    state: masterState
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    CalendarJourneyTimeline(
        initiateDate: "ACHIEVED",
        centurionDate: "14/100 DAYS",
        masterDate: "14/365 DAYS",
        initiateState: .past,
        centurionState: .active,
        masterState: .locked
    )
    .background(Color.stitchBackground)
}

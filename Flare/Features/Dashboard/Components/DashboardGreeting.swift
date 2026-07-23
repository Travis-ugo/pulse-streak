import SwiftUI

struct DashboardGreeting: View {
    let greetingMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(greetingMessage) 🔥")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Your momentum is undeniable today.")
                .font(.subheadline)
                .foregroundColor(Color(hex: "#A1A1A1"))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DashboardGreeting(greetingMessage: "Good Afternoon, Travis")
        .background(Color.stitchBackground)
}

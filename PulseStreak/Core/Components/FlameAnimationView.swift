import SwiftUI

struct FlameAnimationView: View {
    var streakCount: Int
    @State private var isAnimating = false
    
    var flameSize: CGFloat {
        if streakCount > 30 { return 80 }
        if streakCount > 7 { return 60 }
        return 40
    }
    
    var body: some View {
        Image(systemName: "flame.fill")
            .font(.system(size: flameSize))
            .foregroundColor(.orange)
            .scaleEffect(isAnimating ? 1.1 : 0.9)
            .shadow(color: .orange.opacity(0.6), radius: isAnimating ? (streakCount > 7 ? 20 : 10) : 5)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    FlameAnimationView(streakCount: 10)
}

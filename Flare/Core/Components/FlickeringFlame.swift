import SwiftUI

struct FlickeringFlame: View {
    let color: Color
    @State private var isFlickering = false
    
    var body: some View {
        Image(systemName: "flame.fill")
            .foregroundStyle(color)
            .scaleEffect(isFlickering ? 1.15 : 1.0)
            .opacity(isFlickering ? 0.7 : 1.0)
            .animation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
                value: isFlickering
            )
            .onAppear {
                isFlickering = true
            }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        FlickeringFlame(color: .orange)
            .font(.system(size: 60))
    }
}

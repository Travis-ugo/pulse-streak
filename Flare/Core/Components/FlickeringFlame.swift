import SwiftUI

struct FlickeringFlame: View {
    let color: Color
    @State private var isFlickering = false
    
    var body: some View {
        Image(systemName: "flame.fill")
            .foregroundStyle(color)
            .scaleEffect(isFlickering ? 1.2 : 1.0)
            .opacity(isFlickering ? 0.6 : 1.0)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.15)
                        .repeatForever(autoreverses: true)
                ) {
                    isFlickering = true
                }
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

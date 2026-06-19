import SwiftUI

struct StreakSharePreviewView: View {
    let habitName: String
    let streakCount: Int
    @State private var selectedColor: Color
    @Environment(\.dismiss) private var dismiss
    
    private let shareColors: [Color] = [
        .orange,
        .blue,
        .purple,
        .green,
        .red,
        Color(hex: "#FF3B30"), // Crimson
        Color(hex: "#5856D6")  // Indigo
    ]
    
    init(habitName: String, streakCount: Int, initialColorHex: String) {
        self.habitName = habitName
        self.streakCount = streakCount
        self._selectedColor = State(initialValue: Color(hex: initialColorHex))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 32) {
                    // Preview Card (Scaled down for screen)
                    GeometryReader { geo in
                        StreakShareCard(
                            habitName: habitName,
                            streakCount: streakCount,
                            color: selectedColor
                        )
                        .scaleEffect(geo.size.width / 400)
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .frame(height: 450)
                    .padding(.horizontal, 40)
                    .shadow(color: selectedColor.opacity(0.3), radius: 30)
                    
                    // Color Picker
                    VStack(spacing: 16) {
                        Text("SELECT CARD COLOR")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                            .tracking(2)
                        
                        HStack(spacing: 20) {
                            ForEach(shareColors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                            .frame(width: 40, height: 40)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedColor = color
                                        }
                                    }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Share Buttons
                    VStack(spacing: 12) {
                        Button(action: handleInstagramShare) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Share to Instagram Stories")
                            }
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "#F58529"),
                                        Color(hex: "#DD2A7B"),
                                        Color(hex: "#8134AF"),
                                        Color(hex: "#515BD4")
                                    ]),
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        
                        Button(action: handleSystemShare) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("More Share Options")
                            }
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Share Streak")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func handleInstagramShare() {
        ShareService.shared.shareToInstagramStories(
            habitName: habitName,
            streakCount: streakCount,
            color: selectedColor
        )
    }
    
    private func handleSystemShare() {
        ShareService.shared.shareStreak(
            habitName: habitName,
            streakCount: streakCount,
            color: selectedColor
        )
    }
}

#Preview {
    StreakSharePreviewView(habitName: "Coding", streakCount: 120, initialColorHex: "#FF8C00")
}

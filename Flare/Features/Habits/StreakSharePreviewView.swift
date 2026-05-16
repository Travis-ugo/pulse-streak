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
                    
                    // Share Button
                    Button(action: handleShare) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share to Socials")
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
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
    
    private func handleShare() {
        // We pass the color back to the service
        // Since selectedColor is a Color object, we can convert it back to hex or pass it directly
        // For simplicity, let's update ShareService to accept a Color object
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

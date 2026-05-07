import SwiftUI
import SwiftData

struct HabitCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedIcon = "flame.fill"
    @State private var selectedColor = "#FF9F0A" // Default Amber/Orange
    
    let icons = ["flame.fill", "book.fill", "figure.run", "drop.fill", "moon.fill", "bed.double.fill", "macbook", "brain.head.profile", "heart.fill", "fork.knife", "pencil", "cross.case.fill"]
    let colors = ["#FF9F0A", "#32ADE6", "#34C759", "#AF52DE", "#FF2D55", "#FF3B30", "#8E8E93", "#FFCC00"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name (e.g. Read 10 Pages)", text: $title)
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(selectedIcon == icon ? Color(hex: selectedColor).opacity(0.3) : Color.clear)
                                .foregroundColor(selectedIcon == icon ? Color(hex: selectedColor) : .gray)
                                .clipShape(Circle())
                                .onTapGesture {
                                    withAnimation { selectedIcon = icon }
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Color Theme")) {
                    HStack(spacing: 12) {
                        ForEach(colors, id: \.self) { colorHex in
                            Circle()
                                .fill(Color(hex: colorHex))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedColor == colorHex ? 2 : 0)
                                )
                                .onTapGesture {
                                    withAnimation { selectedColor = colorHex }
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveHabit() {
        let newHabit = Habit(title: title, icon: selectedIcon, colorHex: selectedColor)
        modelContext.insert(newHabit)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    HabitCreationView()
        .modelContainer(for: Habit.self, inMemory: true)
}

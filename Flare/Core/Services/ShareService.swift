import SwiftUI
import UIKit

@MainActor
class ShareService {
    static let shared = ShareService()
    
    private init() {}
    
    func shareStreak(habitName: String, streakCount: Int, color: Color) {
        let card = StreakShareCard(
            habitName: habitName,
            streakCount: streakCount,
            color: color
        )
        
        let renderer = ImageRenderer(content: card)
        renderer.scale = 3.0 // High quality
        
        if let image = renderer.uiImage {
            showShareSheet(image: image)
        }
    }
    
    private func showShareSheet(image: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // For iPad compatibility
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = rootViewController.view
            popoverController.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        rootViewController.present(activityViewController, animated: true)
    }
}

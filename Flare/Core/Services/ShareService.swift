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
    
    func shareToInstagramStories(habitName: String, streakCount: Int, color: Color) {
        let card = StreakShareCard(
            habitName: habitName,
            streakCount: streakCount,
            color: color
        )
        
        let renderer = ImageRenderer(content: card)
        renderer.scale = 3.0
        
        guard let image = renderer.uiImage else { return }
        
        guard let urlScheme = URL(string: "instagram-stories://share?source_application=com.flare.streak") else {
            showShareSheet(image: image)
            return
        }
        
        if UIApplication.shared.canOpenURL(urlScheme) {
            guard let imageData = image.pngData() else { return }
            
            var pasteboardItems: [[String: Any]] = [[:]]
            pasteboardItems[0]["com.instagram.sharedSticker.stickerImage"] = imageData
            pasteboardItems[0]["com.instagram.sharedSticker.backgroundTopColor"] = "#0A0A0A"
            pasteboardItems[0]["com.instagram.sharedSticker.backgroundBottomColor"] = "#0A0A0A"
            
            let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
                .expirationDate: Date().addingTimeInterval(60 * 5) // Expire in 5 mins
            ]
            
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
        } else {
            // Instagram not installed, fallback to standard share sheet
            showShareSheet(image: image)
        }
    }
    
    private func showShareSheet(image: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Find topmost presented view controller
        var topViewController = rootViewController
        while let presented = topViewController.presentedViewController {
            topViewController = presented
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // For iPad compatibility
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = topViewController.view
            popoverController.sourceRect = CGRect(
                x: topViewController.view.bounds.midX,
                y: topViewController.view.bounds.midY,
                width: 0,
                height: 0
            )
            popoverController.permittedArrowDirections = []
        }
        
        topViewController.present(activityViewController, animated: true)
    }
}

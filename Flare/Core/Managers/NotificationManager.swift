import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification authorization granted.")
            } else if let error = error {
                print("Notification authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleHabitReminder(id: String, title: String, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Don't let the fire go out!"
        content.body = "Your streak is at risk. Complete your \(title) to stay on fire. 🔥"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "habit_\(id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Successfully scheduled daily reminder for '\(title)' (\(id)) at \(components.hour ?? 0):\(components.minute ?? 0)")
            }
        }
    }
    
    func cancelReminder(for id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["habit_\(id)"])
    }
}

import Foundation
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private init() {}
    
    func startHabitActivity(title: String, streakCount: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled.")
            return
        }
        
        let attributes = HabitAttributes(habitTitle: title, streakCount: streakCount)
        let initialContentState = HabitAttributes.ContentState(progressPercentage: 0.0, remainingTime: "10:00")
        
        do {
            let activity = try Activity<HabitAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil
            )
            print("Successfully started Live Activity: \(activity.id)")
        } catch {
            print("Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    func updateHabitActivity(progress: Double, timeRemaining: String) {
        guard let activity = Activity<HabitAttributes>.activities.first else { return }
        
        let updatedContentState = HabitAttributes.ContentState(progressPercentage: progress, remainingTime: timeRemaining)
        
        Task {
            await activity.update(using: updatedContentState)
        }
    }
    
    func endHabitActivity() {
        guard let activity = Activity<HabitAttributes>.activities.first else { return }
        
        Task {
            await activity.end(using: nil, dismissalPolicy: .immediate)
        }
    }
}

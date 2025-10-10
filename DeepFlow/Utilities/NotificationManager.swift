import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Notificaciones autorizadas")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleSessionCompletionNotification(in seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "¡Sesión Completada! 🎉"
        content.body = "Has terminado tu sesión de focus. ¡Buen trabajo!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

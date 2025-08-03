import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private init() {}
    
    private let userDefaultsKey = "activities_notifications"
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                Logger.info("Notifications allowed")
            } else {
                Logger.error("Notifications denied: \(error?.localizedDescription ?? "No description")")
            }
            
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                Logger.info("Notification status: \(settings.authorizationStatus.rawValue)")
            }
        }
    }
    
    func scheduleNotifications(for activities: [ActivityModel]) {
        for activity in activities {
            scheduleNotification(for: activity)
        }
    }
    
    func scheduleNotification(for activity: ActivityModel) {
        let id = activity.id.uuidString
        let now = Date()
        
        if now.timeIntervalSince(activity.form.date) > 2 * 60 * 60 {
            Logger.info("Skipping notification for expired activity: \(activity.form.title)")
            return
        }
        
        let fifteenMinBefore = activity.form.date.addingTimeInterval(-15 * 60)
        if fifteenMinBefore > now {
            let notificationId = "\(id)_15min"
            if !isNotificationScheduled(notificationId) {
                scheduleReminder(
                    activity: activity,
                    triggerDate: fifteenMinBefore,
                    title: "⏳ Deadline is soon!",
                    body: "Less than 15 minutes left for: \(activity.form.title)",
                    id: notificationId
                )
            }
        }
        
        let oneHourAfter = activity.form.date.addingTimeInterval(60 * 60)
        if oneHourAfter > now {
            let notificationId = "\(id)_overdue"
            if !isNotificationScheduled(notificationId) {
                scheduleReminder(
                    activity: activity,
                    triggerDate: oneHourAfter,
                    title: "Deadline missed!",
                    body: "Activity \"\(activity.form.title)\" is overdue by more than one hour.",
                    id: notificationId
                )
            }
        }
    }
    
    private func scheduleReminder(activity: ActivityModel, triggerDate: Date, title: String, body: String, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: triggerDate
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                Logger.error("Failed to add notification: \(error.localizedDescription)")
            } else {
                Logger.info("Scheduled notification for: \(activity.form.title) at \(triggerDate)")
                self.saveNotificationId(id)
            }
        }
    }
    
    private func getScheduledNotificationIds() -> [String] {
        UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
    }
    
    private func saveNotificationId(_ id: String) {
        var ids = getScheduledNotificationIds()
        if !ids.contains(id) {
            ids.append(id)
            UserDefaults.standard.setValue(ids, forKey: userDefaultsKey)
        }
    }
    
    private func removeNotificationId(_ id: String) {
        var ids = getScheduledNotificationIds()
        if let index = ids.firstIndex(of: id) {
            ids.remove(at: index)
            UserDefaults.standard.setValue(ids, forKey: userDefaultsKey)
        }
    }
    
    private func isNotificationScheduled(_ id: String) -> Bool {
        getScheduledNotificationIds().contains(id)
    }
    
    func removeNotification(for activity: ActivityModel) {
        let id = activity.id.uuidString
        let identifiers = ["\(id)_15min", "\(id)_overdue"]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        for identifier in identifiers {
            removeNotificationId(identifier)
        }
        
        Logger.info("Notifications removed for activity: \(activity.form.title)")
    }
}

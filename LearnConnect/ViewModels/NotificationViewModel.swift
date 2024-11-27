//
//  NotificationViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//

import Foundation
import UserNotifications


class NotificationViewModel{
    private var notifications: [NotificationItem] = []

    var onNotificationsUpdated: (() -> Void)?
    
    init() {
        loadNotifications()
    }
    
    // Bildirim izinlerini al
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                
            } else {
                
            }
        }
    }
    
    // Yeni bir bildirim planla
    func scheduleNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        content.badge = NSNumber(value: notifications.count + 1)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim planlama hatası: \(error.localizedDescription)")
            } else {
                print("Bildirim planlandı!")
            }
        }
        
        // Bildirimi kaydet
        saveNotification(title: title, message: message)
    }
    
    // Bildirimi kaydet
    private func saveNotification(title: String, message: String) {
        let newNotification = NotificationItem(title: title, message: message, date: Date())
        notifications.append(newNotification)
        saveNotificationsToStorage()
        onNotificationsUpdated?()
    }
    
    // Bildirimleri kaydet (UserDefaults kullanımı)
    private func saveNotificationsToStorage() {
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: "notifications")
        }
    }
    
    // Bildirimleri yükle
    private func loadNotifications() {
        if let data = UserDefaults.standard.data(forKey: "notifications"),
           let savedNotifications = try? JSONDecoder().decode([NotificationItem].self, from: data) {
            notifications = savedNotifications
        }
        onNotificationsUpdated?()
    }
    
    // Bildirimleri döndür (tableView için)
    func getNotifications() -> [NotificationItem] {
        return notifications
    }
}

//
//  NotificationSettingsModel.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/04/29.
//

import Foundation
class NotificationSettingsModel: ObservableObject {
    @Published var notificationSettings: [String: Bool] = [:] {
        didSet {
            saveNotificationSettings()
        }
    }
    
    init() {
        loadNotificationSettings()
    }
    
    private func loadNotificationSettings() {
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.object(forKey: "notificationSettings") as? [String: Bool] {
            notificationSettings = savedSettings
        }
    }
    
    private func saveNotificationSettings() {
        let defaults = UserDefaults.standard
        defaults.set(notificationSettings, forKey: "notificationSettings")
    }
}

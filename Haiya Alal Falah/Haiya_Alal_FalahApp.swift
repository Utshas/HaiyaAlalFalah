//
//  Haiya_Alal_FalahApp.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI
import AVFoundation
import UserNotifications

@main
struct Haiya_Alal_FalahApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
            }
        }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var audioPlayer: AVAudioPlayer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
        return true
    }
    
    // For iOS 10 and later
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.categoryIdentifier == "your_notification_category_identifier" {
            let sound_type = UserDefaults.standard.string(forKey: "SavedNotificationSound") ?? "Azan"
            if(sound_type == "Azan"){
                playCustomSound()
            }
        }
        completionHandler()
    }
    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification when the app is in the foreground
        completionHandler([.banner, .sound, .badge])
        if notification.request.content.categoryIdentifier == "your_notification_category_identifier" {
            let sound_type = UserDefaults.standard.string(forKey: "SavedNotificationSound") ?? "Azan"
            if(sound_type == "Azan"){
                playCustomSound()
            }
        }
    }
    
    func playCustomSound() {
        guard let soundURL = Bundle.main.url(forResource: "azan", withExtension: "mp3") else {
            print("Custom sound file not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}



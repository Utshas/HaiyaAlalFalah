//
//  PrayerTimes.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import Adhan
import CoreLocation
import SwiftUI
import UserNotifications

class PrayerTimesAll:NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    @Published var prayers: PrayerTimes?
    @Published var allPrayers: [PrayerTimes?] = []
    @Published var city: String?
    @Published var error: Error?
    var notificationSettings: [String: Bool] = [
        "Fazr": true,
        "Zuhr": true,
        "Asr": true,
        "Maghrib": true,
        "Isha": true
    ]
    
    
    func scheduleNotification(for prayerTime:Date, with prayerName: String){
        print("setting notification for \(prayerName) on \(prayerTime)")
        let content = UNMutableNotificationContent()
        content.title = prayerName
        content.body = "It's time for \(prayerName)"
        
        let prayerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: prayerTime)
        print(prayerComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: prayerComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling prayer: \(error.localizedDescription)")
            }
        }
    }
    
    func schedulePrayerNotification(){
        if allPrayers.isEmpty {
            print("Cannot schedule notifications because prayer times are not available yet!")
            return
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for i in 0..<allPrayers.count{
            let prayerTimes = [
                ("Fazr", allPrayers[i]?.fajr),
                ("Zuhr", allPrayers[i]?.dhuhr),
                ("Asr", allPrayers[i]?.asr),
                ("Maghrib", allPrayers[i]?.maghrib),
                ("Isha", allPrayers[i]?.isha)
            ]
            for (prayerName, prayerTime) in prayerTimes {
                if notificationSettings[prayerName] == true{
                    if let prayerTime = prayerTime as Date?{
                        scheduleNotification(for: prayerTime, with: prayerName)
                    }
                    
                }
            }
        }
    }
    
    func updateNotificationSettings(for prayerName: String, sendNotification: Bool){
        notificationSettings[prayerName] = sendNotification
        schedulePrayerNotification()
        let defaults = UserDefaults.standard
        defaults.set(notificationSettings, forKey: "notificationSettings")
        
    }
    
    override init(){
        super.init()
        
        let defaults = UserDefaults.standard
        if let savedSettings = defaults.object(forKey: "notificationSettings") as? [String:Bool]{
            notificationSettings = savedSettings
            
            print("settings : \(savedSettings)")
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("error sending notification")
            }
            else if granted {
                print("notification granted")
            }
            else{
                print("notification denied")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let coordinates = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let params = CalculationMethod.muslimWorldLeague.params
        let components = Calendar.current.dateComponents([.year, .month, .day], from: location.timestamp)
        var prayerTimes = [PrayerTimes(coordinates: coordinates, date: components, calculationParameters: params)]
        var currentPrayers = PrayerTimes(coordinates: coordinates, date: components, calculationParameters: params)
        if let nextDayDate = Calendar.current.date(byAdding: .day, value: 1, to: location.timestamp){
            let componentsNext = Calendar.current.dateComponents([.year, .month, .day], from: nextDayDate)
            prayerTimes.append(PrayerTimes(coordinates: coordinates, date: componentsNext, calculationParameters: params))
        }
        if let plus2Date = Calendar.current.date(byAdding: .day, value: 2, to: location.timestamp){
            let componentsPlus2 = Calendar.current.dateComponents([.year, .month, .day], from: plus2Date)
            prayerTimes.append(PrayerTimes(coordinates: coordinates, date: componentsPlus2, calculationParameters: params))
        }
        
        DispatchQueue.main.async {
            self.prayers = currentPrayers
            self.allPrayers = prayerTimes
            self.error = nil
            self.schedulePrayerNotification()
        }
        
        geocoder.reverseGeocodeLocation(location){
            placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.error = error
                }
            }else if let placemark = placemarks?.first{
                DispatchQueue.main.async {
                    self.city = placemark.locality ?? placemark.administrativeArea ?? placemark.country ?? "Unspecified"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    func startUpdatingLocation(){
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
    }
    
    func formattedPrayertime(_ prayerTime:Date?)->String{
        guard let prayerTime = prayerTime else {return "NA"}
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: prayerTime)
    }
}

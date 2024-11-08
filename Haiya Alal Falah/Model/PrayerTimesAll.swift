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
    var isTestSet = false
    var notificationSettings: [String: String] = [
        "Fazr": PrayerCall.azan.rawValue,
        "Zuhr": PrayerCall.azan.rawValue,
        "Asr": PrayerCall.azan.rawValue,
        "Maghrib": PrayerCall.azan.rawValue,
        "Isha": PrayerCall.azan.rawValue,
    ]
    
    var calculationMethod: [String: CalculationParameters] = [
        "Muslim World League": CalculationMethod.muslimWorldLeague.params,
        "Moon Sighting Committee": CalculationMethod.moonsightingCommittee.params,
        "Umm Al Qura": CalculationMethod.ummAlQura.params,
        "Kuwait": CalculationMethod.kuwait.params,
        "Karachi": CalculationMethod.karachi.params,
        "North America": CalculationMethod.northAmerica.params,
        "Turkey": CalculationMethod.turkey.params,
        "Egyptian": CalculationMethod.egyptian.params,
        "Dubai": CalculationMethod.dubai.params,
        "Singapore": CalculationMethod.singapore.params,
        "Qatar": CalculationMethod.qatar.params
    ]
    
    
    func scheduleNotification(for prayerTime:Date, with prayerName: String, sound: String = "tone1.mp3"){
        let content = UNMutableNotificationContent()
        content.title = prayerName
        content.body = "It's time for \(prayerName)"
        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: sound))
        content.categoryIdentifier = "haiya-adhan"+sound
        content.interruptionLevel = .timeSensitive
        let prayerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: prayerTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: prayerComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "HAF"+UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling prayer: \(error.localizedDescription)")
            }
        }
    }
    
    func saveMethodToUserDefaults(_ method: String){
        UserDefaults.standard.set(method, forKey: "SavedCalculationMethod")
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
                if notificationSettings[prayerName] != PrayerCall.none.rawValue{
                    if let prayerTime = prayerTime as Date?{
                        
                        let selectedSound = UserDefaults.standard.string(forKey: "notificationSettings-\(prayerName)") ?? "Azan"
                        if(selectedSound == PrayerCall.azan.rawValue){
                            scheduleNotification(for: prayerTime, with: prayerName, sound: "azan1.m4a")
                            scheduleNotification(for: prayerTime.addingTimeInterval(31), with: prayerName, sound: "azan2.m4a")
                            scheduleNotification(for: prayerTime.addingTimeInterval(61), with: prayerName, sound: "azan3.m4a")
                        }else if(selectedSound == PrayerCall.iqamah.rawValue){
                            scheduleNotification(for: prayerTime.addingTimeInterval(61), with: prayerName, sound: "azan.mp3")
                        }
                        else{
                            scheduleNotification(for: prayerTime, with: prayerName)
                        }
                    }
                }
            }
//            test
//             Get the current date
//            if(!isTestSet){
//                let currentDate = Date()
//                let testDate = currentDate.addingTimeInterval(100) // Add 100s to the current date
//                scheduleNotification(for: testDate, with: "test1", sound: "azan1.m4a")
//                scheduleNotification(for: testDate.addingTimeInterval(31), with: "test2", sound:"azan2.m4a")
//                scheduleNotification(for: testDate.addingTimeInterval(62), with: "test3",sound:"azan3.m4a")
//                isTestSet = true
//            }
            
        }
    }
    
    func updateNotificationSettings(for prayerName: String, sendNotification: Bool, notificationType:String){
        self.allPrayers = Context.shared.allPrayers
        notificationSettings[prayerName] = notificationType
        schedulePrayerNotification()
        let defaults = UserDefaults.standard
        defaults.set(notificationSettings[prayerName], forKey: "notificationSettings-\(prayerName)")
        print("prayerName : \(prayerName) , type: \(notificationType) for : notificationSettings-\(prayerName)")
    }
    
    override init(){
        super.init()
        let defaults = UserDefaults.standard
        if let savedSettingsFazr = defaults.object(forKey: "notificationSettings-Fazr") as? String{
            notificationSettings["Fazr"] = savedSettingsFazr
        }
        if let savedSettingsZuhr = defaults.object(forKey: "notificationSettings-Zuhr") as? String{
            notificationSettings["Zuhr"] = savedSettingsZuhr
        }
        if let savedSettingsAsr = defaults.object(forKey: "notificationSettings-Asr") as? String{
            notificationSettings["Asr"] = savedSettingsAsr
        }
        if let savedSettingsMaghrib = defaults.object(forKey: "notificationSettings-Maghrib") as? String{
            notificationSettings["Maghrib"] = savedSettingsMaghrib
        }
        if let savedSettingsIsha = defaults.object(forKey: "notificationSettings-Isha") as? String{
            notificationSettings["Isha"] = savedSettingsIsha
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if error != nil {
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
//        if(Date.timeIntervalSinceReferenceDate - Context.shared.lastUpdatedNotifications < 5*60){
//            return // Stop updating notification within 5 mins
//        }
        Context.shared.lastUpdatedNotifications = Date.timeIntervalSinceReferenceDate
        let coordinates = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var params = CalculationMethod.muslimWorldLeague.params
        if let savedValue = UserDefaults.standard.object(forKey: "SavedCalculationMethod") as? String {
            print(savedValue)
            params = calculationMethod[savedValue] ?? CalculationMethod.muslimWorldLeague.params
        } else {
            self.saveMethodToUserDefaults("Muslim World League")
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: location.timestamp)
        var prayerTimes = [PrayerTimes(coordinates: coordinates, date: components, calculationParameters: params)]
        let currentPrayers = PrayerTimes(coordinates: coordinates, date: components, calculationParameters: params)
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
            Context.shared.allPrayers = self.allPrayers
            self.error = nil
            self.schedulePrayerNotification()
        }
        
        geocoder.reverseGeocodeLocation(location){
            placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.error = error
                    Context.shared.lattitude = 21.4225
                    Context.shared.longitude = 39.8262
                }
            }else if let placemark = placemarks?.first{
                DispatchQueue.main.async {
                    self.city = placemark.locality ?? placemark.administrativeArea ?? placemark.country ?? "World"
                    Context.shared.city = self.city ?? "World"
                }
                Context.shared.lattitude = location.coordinate.latitude
                Context.shared.longitude = location.coordinate.longitude
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.error = error
            Context.shared.lattitude = 21.4225
            Context.shared.longitude = 39.8262
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

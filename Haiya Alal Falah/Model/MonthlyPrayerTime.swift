//
//  MonthlyPrayerTime.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/09/18.
//

import Foundation
import Adhan

class MonthlyPrayerTime{
    let islamicCalendar = Calendar(identifier: .islamic)
    let dateFormatter = DateFormatter()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    let timeFormatter = DateFormatter()
    let calendar = Calendar.current
    
    func getPrayerTimesForIslamicMonths() -> [[String]]{
        var schedule:[[String]] = [[]]
        // Define the calculation method (adjust as needed)
        var params = CalculationMethod.muslimWorldLeague.params
        if let savedValue = UserDefaults.standard.object(forKey: "SavedCalculationMethod") as? String {
            print(savedValue)
            params = PrayerTimesAll().calculationMethod[savedValue] ?? CalculationMethod.muslimWorldLeague.params
        }
        
        // Date formatter to display readable dates
        dateFormatter.dateStyle = .medium
        dateFormatter.calendar = islamicCalendar
        dateFormatter.locale = Locale(identifier: "ar") // Arabic locale for Islamic month names
        timeFormatter.timeStyle = .short

        // Get the current date in the Islamic calendar
        let currentDate = Date()

        // Get the start and end of the current Islamic month
        guard let startOfCurrentIslamicMonth = islamicCalendar.date(from: islamicCalendar.dateComponents([.year, .month], from: currentDate)),
            let startOfNextIslamicMonth = islamicCalendar.date(byAdding: .day, value: 30, to: startOfCurrentIslamicMonth) else {
            print("Error in calculating Islamic month ranges.")
            return schedule
        }
        
        // Print prayer times for the current Islamic month
        let monthNameThisMonth = dateFormatter.monthSymbols[islamicCalendar.component(.month, from: startOfCurrentIslamicMonth) - 1]
        let endOfThisMonth = islamicCalendar.date(byAdding: .day, value: -1, to: startOfNextIslamicMonth)!
        schedule = getPrayerTimes(for: monthNameThisMonth, from: startOfCurrentIslamicMonth, to: endOfThisMonth, params: params)
        return schedule
    }
    
    func getPrayerTimes(for monthName: String, from startDate: Date, to endDate: Date, params:CalculationParameters) ->[[String]]{
        let coordinates = Coordinates(latitude: Context.shared.lattitude, longitude: Context.shared.longitude)
        print("\nPrayer Times for \(monthName):\n")
        var schedule:[[String]] = [[]]
        var date = startDate
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        timeFormatter.timeStyle = .short
        let startMonth = islamicCalendar.dateComponents([.year, .month, .day], from: startDate).month
        while date <= endDate {
            // Convert the Islamic date to the Gregorian equivalent for prayer time calculations
            let gregorianDate = islamicCalendar.date(byAdding: .second, value: 0, to: date) ?? date
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd"
            var formattedDate = formatter.string(from: gregorianDate)
            // Convert the Islamic date components to Gregorian date components
            let gregorianDateComp = calendar.dateComponents(in: TimeZone(abbreviation: "UTC")!, from: gregorianDate)
            if let prayerTimes = PrayerTimes(coordinates: coordinates, date: gregorianDateComp, calculationParameters: params) {
                let hijriDate = islamicCalendar.dateComponents([.year, .month, .day], from: date)
                let islamicDay = hijriDate.day ?? 0
                let islamicMonth = hijriDate.month ?? 0
                if(islamicMonth != startMonth) {
                    break
                }
                let isToday = Calendar.current.isDateInToday(gregorianDate)
                if(isToday){
                    formattedDate = "\(formattedDate) (TODAY)"
                }
                schedule.append(["\(formattedDate)", "\(islamicDay) \(monthName)", "\(currentZoneTime(date: prayerTimes.fajr))", "\(currentZoneTime(date: prayerTimes.dhuhr))", "\(currentZoneTime(date: prayerTimes.asr))", "\(currentZoneTime(date: prayerTimes.maghrib))", "\(currentZoneTime(date: prayerTimes.isha))"])
            }
            // Move to the next day
            date = islamicCalendar.date(byAdding: .day, value: 1, to: date)!
        }
        schedule.remove(at: 0)
        return schedule
    }
    
    func currentZoneTime(date: Date) -> String {
        
        let localTimeZone = TimeZone.current
        let secondsFromGMT = localTimeZone.secondsFromGMT(for: date)
        return timeFormatter.string(from: calendar.date(byAdding: .second, value: secondsFromGMT, to: date) ?? date)
    }

}

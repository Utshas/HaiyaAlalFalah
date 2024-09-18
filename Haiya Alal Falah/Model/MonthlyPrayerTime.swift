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
    let coordinates = Coordinates(latitude: Context.shared.lattitude, longitude: Context.shared.longitude)
    
    func getPrayerTimesForIslamicMonths(forNextMonth:Bool = false) -> [[String]]{
        var schedule:[[String]] = [[]]
        // Define the calculation method (adjust as needed)
        var params = CalculationMethod.muslimWorldLeague.params
        params.madhab = .shafi
        
        // Date formatter to display readable dates
        dateFormatter.dateStyle = .medium
        dateFormatter.calendar = islamicCalendar
        dateFormatter.locale = Locale(identifier: "ar") // Arabic locale for Islamic month names
        timeFormatter.timeStyle = .short

        // Get the current date in the Islamic calendar
        let currentDate = Date()

        // Get the start and end of the current Islamic month
        guard let startOfCurrentIslamicMonth = islamicCalendar.date(from: islamicCalendar.dateComponents([.year, .month], from: currentDate)),
              let startOfNextIslamicMonth = islamicCalendar.date(byAdding: .month, value: 1, to: startOfCurrentIslamicMonth),
              let startOfMonthAfterNext = islamicCalendar.date(byAdding: .month, value: 1, to: startOfNextIslamicMonth),
              let endOfNextIslamicMonth = islamicCalendar.date(byAdding: .day, value: -1, to: startOfMonthAfterNext) else {
            print("Error in calculating Islamic month ranges.")
            return schedule
        }
        
        // Print prayer times for the current Islamic month
        if forNextMonth{
            let monthNameNextMonth = dateFormatter.monthSymbols[islamicCalendar.component(.month, from: startOfNextIslamicMonth) - 1]
            schedule = getPrayerTimes(for: monthNameNextMonth, from: startOfNextIslamicMonth, to: endOfNextIslamicMonth, params: params)
        }else{
            let monthNameThisMonth = dateFormatter.monthSymbols[islamicCalendar.component(.month, from: startOfCurrentIslamicMonth) - 1]
            let endOfThisMonth = islamicCalendar.date(byAdding: .day, value: -1, to: startOfNextIslamicMonth)!
            schedule = getPrayerTimes(for: monthNameThisMonth, from: startOfCurrentIslamicMonth, to: endOfThisMonth, params: params)
        }

        return schedule
        
    }
    
    func getPrayerTimes(for monthName: String, from startDate: Date, to endDate: Date, params:CalculationParameters) ->[[String]]{
        print("\nPrayer Times for \(monthName):\n")
        var schedule:[[String]] = [[]]
        var date = startDate
        while date <= endDate {
            // Convert the Islamic date to the Gregorian equivalent for prayer time calculations
            let gregorianDate = islamicCalendar.date(byAdding: .second, value: 0, to: date) ?? date
            // Get the Islamic date components (year, month, day) from the Islamic calendar
            let islamicDateComponents = islamicCalendar.dateComponents([.year, .month, .day], from: date)

            // Convert the Islamic date components to Gregorian date components
            var gregorianDateComp = DateComponents()
            gregorianDateComp.year = islamicDateComponents.year
            gregorianDateComp.month = islamicDateComponents.month
            gregorianDateComp.day = islamicDateComponents.day
            if let prayerTimes = PrayerTimes(coordinates: coordinates, date: gregorianDateComp, calculationParameters: params) {
                let hijriDate = islamicCalendar.dateComponents([.year, .month, .day], from: date)
                let islamicDay = hijriDate.day ?? 0
                print("Date (Hijri): \(islamicDay) \(monthName)")
                print("Fajr: \(timeFormatter.string(from: prayerTimes.fajr))")
                print("Dhuhr: \(timeFormatter.string(from: prayerTimes.dhuhr))")
                print("Asr: \(timeFormatter.string(from: prayerTimes.asr))")
                print("Maghrib: \(timeFormatter.string(from: prayerTimes.maghrib))")
                print("Isha: \(timeFormatter.string(from: prayerTimes.isha))")
                print("-----------")
                schedule.append(["\(islamicDay) \(monthName)", "\(timeFormatter.string(from: prayerTimes.fajr))", "\(timeFormatter.string(from: prayerTimes.dhuhr))", "\(timeFormatter.string(from: prayerTimes.asr))", "\(timeFormatter.string(from: prayerTimes.maghrib))", "\(timeFormatter.string(from: prayerTimes.isha))"])
            }
            
            // Move to the next day
            date = islamicCalendar.date(byAdding: .day, value: 1, to: date)!
        }
        return schedule
    }

}

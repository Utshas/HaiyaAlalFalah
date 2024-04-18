//
//  AthanTimeTable.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/25.
//

import SwiftUI

struct AthanTimeTable: View {
    let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    let prayerClass: PrayerTimesAll
    var body: some View {
        VStack(alignment: .leading){
            LazyVGrid(columns: gridItems, spacing: 6){
                ForEach(0..<1){_ in 
                    PrayerTimeTableItem(prayerName: "Fajr", prayerTime: prayerClass.formattedPrayertime(prayerClass.prayers?.fajr))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(.ultraThinMaterial)
                        .presentationCornerRadius(22)
                    PrayerTimeTableItem(prayerName: "Sunrise", prayerTime: prayerClass.formattedPrayertime(prayerClass.prayers?.sunrise))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(.ultraThinMaterial)
                        .presentationCornerRadius(22)
                    PrayerTimeTableItem(prayerName: "Duhr", prayerTime: prayerClass.formattedPrayertime(prayerClass.prayers?.dhuhr))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(.ultraThinMaterial)
                        .presentationCornerRadius(22)
                    PrayerTimeTableItem(prayerName: "Asr", prayerTime: prayerClass.formattedPrayertime(prayerClass.prayers?.asr))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(.ultraThinMaterial)
                        .presentationCornerRadius(22)
                    PrayerTimeTableItem(prayerName: "Maghrib", prayerTime: prayerClass.formattedPrayertime(prayerClass.prayers?.maghrib))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(.ultraThinMaterial)
                        .presentationCornerRadius(22)
                    PrayerTimeTableItem(prayerName: "Isha", prayerTime: prayerClass.formattedPrayertime(prayerClass.prayers?.isha))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(.ultraThinMaterial)
                        .presentationCornerRadius(22)
                }
            }
        }
    }
}

#Preview {
    AthanTimeTable(prayerClass: PrayerTimesAll())
}

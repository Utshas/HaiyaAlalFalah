//
//  CalendarView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/09/18.
//

import SwiftUI

struct CalendarView: View {
    // Define the grid layout with 6 columns
    let rowDataThisMonth: [[String]] = MonthlyPrayerTime().getPrayerTimesForIslamicMonths()
    let rowDataNextMonth: [[String]] = MonthlyPrayerTime().getPrayerTimesForIslamicMonths(forNextMonth: true)
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<rowDataThisMonth.count, id: \.self) { row in
                            ForEach(0..<rowDataThisMonth[row].count, id: \.self) { col in
                                Text(rowDataThisMonth[row][col])
                                    .frame(minWidth: 50, minHeight: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .border(Color.black, width: 1)
                            }
                        }
                    }
                    .padding()
                }
    }
}

#Preview {
    CalendarView()
}

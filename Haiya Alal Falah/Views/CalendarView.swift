//
//  CalendarView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/09/18.
//

import SwiftUI

struct CalendarView: View {
    // Define the grid layout with 6 columns
    @State private var rowDataThisMonth: [[String]] = MonthlyPrayerTime().getPrayerTimesForIslamicMonths()
    @State private var rowDataNextMonth: [[String]] = MonthlyPrayerTime().getPrayerTimesForIslamicMonths(forNextMonth: true)
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            if colorScheme == .dark {
                // For dark mode, use dark green color
                Color(.sRGB, red: 0, green: 0.11, blue: 0)
                    .ignoresSafeArea()
            } else {
                // For light mode, use light silver color
                Color(.sRGB, red: 0.98, green: 0.95, blue: 1)
                    .ignoresSafeArea()
            }
            VStack{
                Spacer()
                Text("Monthly Prayer Schedule").fontWeight(.bold)
                    .foregroundStyle(Color.orange)
                    .font(.system(size: 22))
                ScrollView {  // Scroll vertically to accommodate all rows
                    VStack {  // Ensure the container expands
                        // Loop through each row
                        ForEach(0..<rowDataThisMonth.count, id: \.self) { row in
                            Divider()
                            Text("\(rowDataThisMonth[row][1]) | \(rowDataThisMonth[row][0])")
                                .bold()
                                .padding(.top,15)
                            HStack{
                                // Loop through each column in the current row
                                ForEach(2..<rowDataThisMonth[row].count, id: \.self) { col in
                                    Text(rowDataThisMonth[row][col])
                                        .frame(minWidth: 60, minHeight: 40)
                                        .background(Color.gray.opacity(0.2))
                                }
                            }
                        }
                    }
                }.onAppear {
                    printit()
                }
                Spacer()
            }
        }
    }
    
    func printit(){
        print(rowDataThisMonth)
    }
}

#Preview {
    CalendarView()
}

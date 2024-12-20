//
//  CalendarView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/09/18.
//

import SwiftUI

struct CalendarView: View {
    // Define the grid layout with 6 columns
    @State private var rowData:[[String]] = MonthlyPrayerTime().getPrayerTimesForIslamicMonths()
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
                        ForEach(0..<rowData.count, id: \.self) { row in
                            if rowData[row][0].contains("TODAY") || (row > 0 && rowData[row-1][0].contains("TODAY")) {
                                Divider()
                                    .frame(height: 5) // Thicker divider
                                    .background(Color.orange) // Different color
                            } else {
                                Divider()
                                    .frame(height: 1) // Regular divider
                                    .background(Color.white) // Regular color
                            }
                            Text("\(rowData[row][1]) | \(rowData[row][0])")
                                .bold()
                                .padding(.top,10)
                            HStack{
                                // Loop through each column in the current row
                                ForEach(2..<rowData[row].count, id: \.self) { col in
                                    Text(rowData[row][col])
                                        .frame(minWidth: 62, minHeight: 35)
                                        .background(Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }.onAppear{
                rowData = MonthlyPrayerTime().getPrayerTimesForIslamicMonths()
            }
        }
    }
}

#Preview {
    CalendarView()
}

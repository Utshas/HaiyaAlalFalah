//
//  PrayerTimeView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI

struct PrayerTimeView: View {
    let prayerName: String
    let prayerTime: Date
    let location: String
    let currentDate = Date()
    let gregCalendar = Calendar(identifier: .gregorian)
    let hijrCalendar = Calendar(identifier: .islamicUmmAlQura)
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            VStack(spacing: 20){
                VStack{
                    HStack{
                        Text("Haiya").font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.yellow)
                        Text("Alal").font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                        Text("Falah").font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                    .padding()
                    Text("\(prayerName.uppercased())")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                    
                }
                .padding(.horizontal)
                
                VStack {
                    Text("\(prayerTime, style: .timer)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                HStack{   
                    Text("\(getFormattedDate(date: currentDate, calendar: hijrCalendar))")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            HStack{
                Text("\(location)").bold()
                Image(systemName: "location.circle.fill")
                    .foregroundStyle(.orange)
                
                Spacer()
                Text("Today").font(.caption)
            }.padding(.bottom).padding(.horizontal)
        }
    }
    
    func getFormattedDate(date:Date, calendar: Calendar)-> String{
        let components = calendar.dateComponents([.year,.month,.day], from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = "yyyy MMM dd"
        return dateFormatter.string(from: calendar.date(from: components) ?? date)
        
    }
}

#Preview {
    PrayerTimeView(prayerName: "Fazr", prayerTime: Date.now, location: "Dhaka").preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}

//
//  PrayerTimeTableItem.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI

struct PrayerTimeTableItem: View {
    let prayerName: String
    let prayerTime: String
    @State var isPlaying = true
    
    var body: some View {
        VStack{
            VStack(spacing: 20) {
                VStack{
                    ZStack{
                        VStack(alignment: .trailing){
                            Button(action: {
                                isPlaying.toggle()
                            }, label: {
                                Image(systemName: "clock.circle.fill")
                                    .padding(.leading, 60)
                                    .padding(.bottom, 70)
                                    .foregroundStyle(.orange)
                            })
                        }
                        VStack(alignment: .leading){
                            Text(prayerName)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                                .frame(maxWidth: 85, alignment: .leading)
                            Text(prayerTime)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }.padding(.trailing, 10)
                            .padding(.top,30)
                    }
                }
            }
            .padding(.horizontal,10)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    PrayerTimeTableItem(prayerName: "Fajr", prayerTime: "04:19").preferredColorScheme(.dark)
}

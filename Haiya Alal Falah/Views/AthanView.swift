//
//  AthanView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/25.
//

import SwiftUI

struct AthanView: View {
    @ObservedObject var prayerClass:PrayerTimesAll
    @State private var isPresented = false
    @State private var isShowSettings = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            if colorScheme == .dark {
                // For dark mode, use dark green color
                Color(.sRGB, red: 0, green: 0.1, blue: 0)
                    .ignoresSafeArea()
            } else {
                // For light mode, use light silver color
                Color(.sRGB, red: 0.97, green: 0.97, blue: 1)
                    .ignoresSafeArea()
            }
            ScrollView{
                if prayerClass.error != nil {
                    VStack{
                        LocationNotFoundView()
                    }
                    .onAppear{
                        isPresented = true
                    }
                } else {
                    if let prayers = prayerClass.prayers {
                        if let nextPrayer = prayers.nextPrayer(){
                            PrayerTimeView(prayerName: "\(nextPrayer)", prayerTime: prayers.time(for: nextPrayer), location: prayerClass.city ?? "__")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            PrayerTimeView(prayerName: "Fazr", prayerTime:PrayerTimesAll().nextFazrPrayer(), location: prayerClass.city ?? "__")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        Text(getSahriIftar())
                            .padding(.top,5)
                            .font(.caption2)
                            .bold()
                        AthanTimeTable(prayerClass: prayerClass)
                            .listRowSeparator(.hidden)
                            .onAppear {
                                isPresented = false
                            }
                        
                        Text("إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ").padding(.top,50).foregroundStyle(Color.orange)
                        Text("Surely, prayer keeps (one) away from indecency and evil. [ Ankabut : 45 ]").padding(.horizontal)
                    }
                }
            }
            .padding(.top)
            .onAppear{
                prayerClass.startUpdatingLocation()
            }
            .onDisappear{
                prayerClass.stopUpdatingLocation()
            }
        }
    }
    func getSahriIftar() -> String{
        var sahri = Date()
        var iftar = Date()
        if let prayers = prayerClass.prayers {
            if let nextPrayer = prayers.nextPrayer(){
                if(nextPrayer == .fajr){//today fnm
                    sahri = prayers.fajr
                    iftar = prayers.maghrib
                }else if nextPrayer == .isha{//tomorrow fnm
                    sahri = prayerClass.nextFazrPrayer()
                    iftar = prayerClass.nextMaghribPrayer()
                }else{//tomorrow f today m
                    sahri = prayerClass.nextFazrPrayer()
                    iftar = prayers.maghrib
                }
                
            }
            else{
                sahri = prayerClass.nextFazrPrayer()
                iftar = prayerClass.nextMaghribPrayer()
            }
        }
        // Format the times in the current time zone
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone.current // Ensure local time zone is used

            let sahriString = formatter.string(from: sahri)
            let iftarString = formatter.string(from: iftar)
            return "SUHUR: \(sahriString)         IFTAR: \(iftarString)"
    }
}

#Preview {
    AthanView(prayerClass: PrayerTimesAll()).preferredColorScheme(.light)
}

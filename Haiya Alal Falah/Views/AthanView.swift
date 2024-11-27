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
                Color(.sRGB, red: 0.96, green: 0.97, blue: 1)
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
                        HStack{
                                
                            Text(getSahriIftar()[0])
                                .padding(.top,7)
                                .font(.caption2)
                            Text(getSahriIftar()[1])
                                .padding(.top,6)
                                .font(.caption)
                                .bold()
                            Spacer()
                            Text(getSahriIftar()[2])
                            .padding(.top,7)
                            .font(.caption2)
                            Text(getSahriIftar()[3])
                                .padding(.top,6)
                                .font(.caption)
                                .bold()
                            }.padding(.bottom,7)
                        
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
    func getSahriIftar() -> [String]{
        var sahri = Date()
        var iftar = Date()
        var suhurTitle = "SUHUR"
        var iftarTitle = "IFTAR"
        if let prayers = prayerClass.prayers {
            if let nextPrayer = prayers.nextPrayer(){
                if(nextPrayer == .fajr){//today fnm
                    sahri = prayers.fajr
                    iftar = prayers.maghrib
                    suhurTitle += "(today)"
                    iftarTitle += "(today)"
                }else if nextPrayer == .isha{//tomorrow fnm
                    sahri = prayerClass.nextFazrPrayer()
                    iftar = prayerClass.nextMaghribPrayer()
                    suhurTitle += "(tomorrow)"
                    iftarTitle += "(tomorrow)"
                }else{//tomorrow f today m
                    sahri = prayerClass.nextFazrPrayer()
                    iftar = prayers.maghrib
                    suhurTitle += "(tomorrow)"
                    iftarTitle += "(today)"
                }
                
            }
            else{
                sahri = prayerClass.nextFazrPrayer()
                iftar = prayerClass.nextMaghribPrayer()
                suhurTitle += "(tomorrow)"
                iftarTitle += "(tomorrow)"
            }
        }
        // Format the times in the current time zone
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone.current // Ensure local time zone is used

            let sahriString = formatter.string(from: sahri)
            let iftarString = formatter.string(from: iftar)
        return ["🌏 \(suhurTitle)", "\(sahriString)", "🌕 \(iftarTitle)", "\(iftarString)"]
    }
}

#Preview {
    AthanView(prayerClass: PrayerTimesAll()).preferredColorScheme(.light)
}

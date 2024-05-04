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
    var body: some View {
            NavigationView{
                ZStack{
                    Color("bg")
                        .ignoresSafeArea()
                    ScrollView{
                        if let error = prayerClass.error {
                            VStack{}
                            .onAppear{
                                isPresented = true
                            }
                        } else {
                            if let prayers = prayerClass.prayers {
                                if let nextPrayer = prayers.nextPrayer(){
                                    PrayerTimeView(prayerName: "\(nextPrayer)", prayerTime: prayers.time(for: nextPrayer), location: prayerClass.city ?? "__")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                } else {
                                            PrayerTimeView(prayerName: "Imsak", prayerTime: Date(), location: prayerClass.city ?? "__")
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        AthanTimeTable(prayerClass: prayerClass)
                                            .listRowSeparator(.hidden)
                                            .onAppear {
                                                isPresented = false
                                            }
                                Text("إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ").padding(.top,50).foregroundStyle(Color.orange)
                                Text("Surely, prayer keeps (one) away from indecency and evil. [ Ankabut : 45 ]").padding(.horizontal).foregroundStyle(Color.green)
                                    }
                                }
                            }
                    .padding(.top)
                    .fullScreenCover(isPresented: $isPresented, content: { LocationNotFoundView() })
                    
                    .onAppear{
                        prayerClass.startUpdatingLocation()
                    }
                    .onDisappear{
                        prayerClass.stopUpdatingLocation()
                          }
                       }
                
                    }
          
                }
              
            }

#Preview {
    AthanView(prayerClass: PrayerTimesAll())
}

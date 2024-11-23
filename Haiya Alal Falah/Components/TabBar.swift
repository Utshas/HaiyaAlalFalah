//
//  TabBar.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1
                           AthanHome()
                               .tabItem {
                                   Image(systemName: "clock.badge.fill")
                                   Text("Athan Time")
                               }
                               .tag(0)
            
                           CompassView()
                               .tabItem {
                                   Image(systemName: "safari.fill")
                                   Text("Compass")
                               }
                               .tag(1)
            
                           SettingsView(prayerClass: PrayerTimesAll())
                               .tabItem {
                                   Image(systemName: "gear")
                                   Text("Settings")
                               }
                               .tag(2)
            

                        LearningView()
                            .tabItem {
                                Image(systemName: "book")
                                Text("Motivations")
                            }
                            .tag(3)
            
                        CalendarView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Montly Schedule")
                            }
                            .tag(4)
                       }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Enable swiping
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Optional: Customize the index dots
                
        .accentColor(.orange)
        }

}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

//
//  TabBar.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab = 0
    private let tabCount = 5

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
        .tabViewStyle(DefaultTabViewStyle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    if horizontalAmount < -40 { // Swipe left
                        if selectedTab < tabCount - 1 {
                            selectedTab += 1
                        }
                    } else if horizontalAmount > 40 { // Swipe right
                        if selectedTab > 0 {
                            selectedTab -= 1
                        }
                    }
                }
        )
        .accentColor(.orange)
        }

}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

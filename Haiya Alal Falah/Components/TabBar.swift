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
            
                           // Tab 2
                           CompassView()
                               .tabItem {
                                   Image(systemName: "safari.fill")
                                   Text("Compass")
                               }
                               .tag(1)
            
                           // Tab 3
                           Text("Tab 3")
                               .tabItem {
                                   Image(systemName: "gear")
                                   Text("Settings")
                               }
                               .tag(2)
                       }
        .accentColor(.blue)
        }

}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

//
//  SettingsView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/04/29.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var prayerClass:PrayerTimesAll
    @State private var isDropdownVisible = false
    @StateObject var notificationSettingsModel = NotificationSettingsModel()
    @State private var switchStates = [false, false, false, false, false]
    let prayerNames = ["Fazr", "Sunrise", "Zuhr", "Asr", "Maghrib", "Isha"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Calculation Method:")
                Spacer()
                Button(action: {
                    self.isDropdownVisible.toggle()
                }) {
                    Text("Select Method")
                }
                if isDropdownVisible {
                    Picker("Options", selection: .constant(0)) {
                        ForEach(0..<prayerNames.count) { index in
                            Text(self.prayerNames[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            
            ForEach(0..<prayerNames.count){ key in
                HStack {
                    Text(prayerNames[key])
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { self.notificationSettingsModel.notificationSettings[prayerNames[key]] ?? false },
                        set: { newValue in
                            self.notificationSettingsModel.notificationSettings[prayerNames[key]] = newValue
                        }
                    ))
                }
            }
            
                        
        }
        .padding()
    }
}

#Preview {
    SettingsView(prayerClass: PrayerTimesAll())
}

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
    @State private var isTextVisible = true
    @State private var selectedMethod = ""
    @StateObject var notificationSettingsModel = NotificationSettingsModel()
    @State private var switchStates = [false, false, false, false, false]
    private let prayerNames = ["Fazr", "Sunrise", "Zuhr", "Asr", "Maghrib", "Isha"]
    private let calculationMethods = ["Muslim World League","Moon Sighting Committee","Umm Al Qura","Kuwait","Karachi","North America","Turkey"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Calculation Method:").fontWeight(.bold)
            HStack {
                Spacer()
                Button(action: {
                    self.isDropdownVisible.toggle()
                    self.isTextVisible.toggle()
                }) {
                    if(isTextVisible){
                        Text("Select Method")
                    }
                }
                if isDropdownVisible {
                    Picker("Options", selection: $selectedMethod) {
                            ForEach(0..<calculationMethods.count) { index in
                                CustomPickerRow(text: self.calculationMethods[index]) {
                                            print("Pressed \(self.calculationMethods[index])")
                                        }
                                        .tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                }
            }
            
            Divider()
            Text("Notification for prayers").fontWeight(.bold)
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
    struct CustomPickerRow: View {
        var text: String
        var action: () -> Void
        
        var body: some View {
            Text(text)
                .onSubmit {
                    print("y")
                }
        }
    }
}

#Preview {
    SettingsView(prayerClass: PrayerTimesAll())
}

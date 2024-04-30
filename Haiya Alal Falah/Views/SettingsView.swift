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
    @StateObject var notificationSettingsModel = NotificationSettingsModel()
    @State private var switchStates = [false, false, false, false, false]
    private let prayerNames = ["Fazr", "Sunrise", "Zuhr", "Asr", "Maghrib", "Isha"]
    private let calculationMethods = ["Moon Sighting Committee","Umm Al Qura","Kuwait","Muslim World League","Karachi","North America","Turkey"]
    @State private var selectedMethod = UserDefaults.standard.string(forKey: "SavedCalculationMethod") ?? "Muslim World League"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Calculation Method").fontWeight(.bold)
                .foregroundStyle(Color.orange)
                .font(.system(size: 22))
            Text("\(selectedMethod.capitalized)")
                .foregroundStyle(Color.green)
                .font(.system(size: 11))
            Picker("Options", selection: $selectedMethod) {
                    ForEach(0..<calculationMethods.count) { index in
                        Text(calculationMethods[index])
                            .tag(calculationMethods[index])
                    }
            }
            .onChange(of: selectedMethod){ _ in
                prayerClass.saveMethodToUserDefaults(selectedMethod)
            }
            .pickerStyle(.wheel)
           
            Divider().padding(.bottom)
            Text("Notification for prayers").fontWeight(.bold)
                .foregroundStyle(Color.orange)
                .font(.system(size: 22))
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
        .padding(.top,0)
    }
    struct CustomPickerRow: View {
        var text: String
        var action: () -> Void
        var body: some View {
            Text(text)
        }
    }
}

#Preview {
    SettingsView(prayerClass: PrayerTimesAll())
}

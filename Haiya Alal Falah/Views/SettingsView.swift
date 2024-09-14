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
    private let prayerNames = ["Fazr", "Zuhr", "Asr", "Maghrib", "Isha"]
    private let calculationMethods = ["Moon Sighting Committee","Umm Al Qura","Kuwait","Muslim World League","Karachi","North America","Turkey"]
    @State private var selectedMethod = UserDefaults.standard.string(forKey: "SavedCalculationMethod") ?? "Muslim World League"
    @State private var selectedSound:[String] = [
        UserDefaults.standard.string(forKey: "notificationSettings-Fazr") ?? "Azan",
        UserDefaults.standard.string(forKey: "notificationSettings-Zuhr") ?? "Azan",
        UserDefaults.standard.string(forKey: "notificationSettings-Asr") ?? "Azan",
        UserDefaults.standard.string(forKey: "notificationSettings-Maghrib") ?? "Azan",
        UserDefaults.standard.string(forKey: "notificationSettings-Isha") ?? "Azan"
    ]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            if colorScheme == .dark {
                // For dark mode, use dark green color
                Color(.sRGB, red: 0, green: 0.1, blue: 0)
                    .ignoresSafeArea()
            } else {
                // For light mode, use light silver color
                Color(.sRGB, red: 0.97, green: 0.96, blue: 1)
                    .ignoresSafeArea()
            }
            VStack(alignment: .leading) {
                HStack(){
                    Image(uiImage: UIImage(named: "t_icon")!)
                        .resizable()
                        .frame(width: 40, height: 50)
                        .padding(.top, -10)
                    Text("Calculation Method").fontWeight(.bold)
                        .foregroundStyle(Color.orange)
                        .font(.system(size: 22))
                }.padding(.bottom,-10)
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
                Spacer()
                Divider().padding(.bottom)
                Spacer()
                HStack(){
                    Image(uiImage: UIImage(named: "t_icon")!)
                        .resizable()
                        .frame(width: 40, height: 50)
                        .padding(.top, -10)
                    Text("Notification Type").fontWeight(.bold)
                        .foregroundStyle(Color.orange)
                        .font(.system(size: 22))
                }
                ForEach(0..<prayerNames.count){ key in
                    HStack {
                        Text(prayerNames[key])
                        Spacer()
                        Picker("Options", selection: $selectedSound[key]) {
                            Text("Full Azan").tag("Azan")
                            Text("Haiya Alal Falah").tag("Iqamah")
                            Text("None").tag("None")
                        }
                        .onChange(of: selectedSound){ _ in
                            prayerClass.updateNotificationSettings(for: prayerNames[key], sendNotification: true, notificationType: selectedSound[key])
                        }
                        .pickerStyle(.segmented)
                    }.padding(.bottom,10)
                }
                
                Spacer()
            }
            .padding()
            .padding(.top,0)
        }
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

//
//  SettingsView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/04/29.
//

import SwiftUI

struct SettingsView: View {
    @State private var isDropdownVisible = false
    @State private var switchStates = [false, false, false, false, false]
    let dropdownOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    
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
                        ForEach(0..<dropdownOptions.count) { index in
                            Text(self.dropdownOptions[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            
            ForEach(0..<5) { index in
                HStack {
                    Text("Label \(index + 1):")
                    Spacer()
                    Toggle("", isOn: self.$switchStates[index])
                }
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}

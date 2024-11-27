//
//  ContentView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI

struct ContentView: View {
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
            VStack {
                TabBar()
            }.padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}

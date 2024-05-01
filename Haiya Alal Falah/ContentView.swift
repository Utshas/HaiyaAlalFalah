//
//  ContentView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabBar()
        }
        .padding()
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    ContentView().preferredColorScheme(.light)
}

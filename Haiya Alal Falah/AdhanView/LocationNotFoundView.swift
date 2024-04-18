//
//  LocationNotFoundView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/03/25.
//

import SwiftUI

struct LocationNotFoundView: View {
    var body: some View {
        ZStack(alignment: .center){
            Color.clear
                .ignoresSafeArea(.all)
                .background(.ultraThinMaterial)
            VStack(spacing: 30){
                Image(systemName: "location.fill")
                    .font(.system(size: 86))
                    .foregroundStyle(.orange)
                
                HStack{
                    Text("Correct")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Location")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.center)
                }
                Text("To access the most accurate prayer times instantly through the salah app, you need to allow location access.")
                    .font(.system(size:15))
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .padding()
                Text("We only need the location while you are using the app. This enables us to provide prayer times specific to your location and is not shared with any other parties.")
                    .font(.system(size:15))
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                
                Button{
                    if let url = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)}
                } label: {
                    Image(systemName: "location.fill")
                        .font(.system(size: 22))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    Text("Allow Location Access")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundStyle(.white)
                }
                .padding()
                .background(.orange)
                .cornerRadius(15)
                
                Text("Enable location access from settings")
            }
            .padding(30)
        }
    }
}

#Preview {
    LocationNotFoundView().preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}

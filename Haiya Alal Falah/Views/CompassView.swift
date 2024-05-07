//
//  CompassView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/04/21.
//

import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var locationManagerDelegate = LocationManagerDelegate()
    @State private var heading: Double = 0
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack{
            if colorScheme == .dark {
                // For dark mode, use dark green color
                Color(.sRGB, red: 0, green: 0.1, blue: 0)
                    .ignoresSafeArea()
            } else {
                // For light mode, use light silver color
                Color(.sRGB, red: 0.97, green: 0.97, blue: 1)
                    .ignoresSafeArea()
            }
            VStack {
                HStack(){
                    Image(uiImage: UIImage(named: "t_icon")!)
                        .resizable()
                        .frame(width: 40, height: 50)
                        .padding(.top, 40)
                    Text("Qibla Direction ").padding(.top,45)
                        .font(.system(size: 24))
                        .bold()
                        .foregroundStyle(.orange)
                }
                Spacer()
                VStack{
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 50, height: 50)
                        Image(uiImage: UIImage(named: "kabah")!)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 100))
                        .padding()
                        .foregroundStyle(.orange)
                    
                    Text("Rotation : \(Int(heading))°")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundStyle(.orange)
                }
                .rotationEffect(.degrees(calculateHeadingToMecca(currentHeading: heading)))
                Spacer()
                HStack{
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 20))
                        .padding(.bottom,50)
                        .foregroundStyle(.orange)
                    Text("Location: \(Context.shared.city.capitalized)").padding(.bottom,50)
                        .bold()
                }.padding(.top,30)
            }
        }
        .onAppear {
            locationManagerDelegate.startUpdatingHeading()
        }
        .onDisappear {
            locationManagerDelegate.stopUpdatingHeading()
        }
        .onChange(of: locationManagerDelegate.heading) { newHeading in
            heading = newHeading
        }
    }
    
    private func calculateHeadingToMecca(currentHeading: Double) -> Double {
        // Coordinates of Mecca
        let meccaLatitude = 21.4225
        let meccaLongitude = 39.8262
        let currentLatitude = Context.shared.lattitude
        let currentLongitude = Context.shared.longitude
        
        // Calculate the angle between current location and Mecca
        let deltaLongitude = meccaLongitude - currentLongitude
        let y = sin(deltaLongitude) * cos(meccaLatitude)
        let x = cos(currentLatitude) * sin(meccaLatitude) - sin(currentLatitude) * cos(meccaLatitude) * cos(deltaLongitude)
        let angleToMecca = atan2(y, x)
        // Convert radians to degrees
        let degreesToMecca = angleToMecca * 180 / .pi
        // Adjust the angle based on the current heading
        let headingToMecca = 360 - (degreesToMecca - currentHeading)
        return -headingToMecca
    }
}



#Preview {
    CompassView()
}

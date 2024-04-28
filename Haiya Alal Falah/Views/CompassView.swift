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

    var body: some View {
        VStack {
            Text("Heading: \(Int(heading))°")
                .padding()
            
            Image(systemName: "location.north.fill")
                .rotationEffect(.degrees(calculateHeadingToMecca(currentHeading: heading)))
                .font(.system(size: 100))
                .padding()
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
        let currentLatitude = 31.913417646154066
        let currentLongitude = 131.42908258778093
        
        // Coordinates of the current location (you can get these from locationManagerDelegate)
        // GET CURRENT LAT LONG
        
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

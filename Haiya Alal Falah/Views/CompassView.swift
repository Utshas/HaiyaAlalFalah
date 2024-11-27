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
    @State private var angleToMecca: Double = 0
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
                    
                    Text("Rotation : \(Int(heading))° \(Int(angleToMecca))°")
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
        .onChange(of: locationManagerDelegate.heading) { newHeading in
            angleToMecca = calculateHeadingToMecca(currentHeading: newHeading)
        }
    }
    
    private func calculateHeadingToMecca(currentHeading: Double) -> Double {
        // Coordinates of Mecca
        let meccaLatitude = 21.4225
        let meccaLongitude = 39.8262
        
        // Coordinates of the current location (you can get these from locationManagerDelegate)
        let currentLatitude = Context.shared.lattitude//23.8103
        let currentLongitude =  Context.shared.longitude//90.4125
        
        // Calculate the angle between current location and Mecca using Haversine formula
        let angleToMecca = calculateBearingBetweenPoints(
            fromLatitude: degreesToRadians(currentLatitude),
            fromLongitude: degreesToRadians(currentLongitude),
            toLatitude: degreesToRadians(meccaLatitude),
            toLongitude: degreesToRadians(meccaLongitude)
        )
        
        // Adjust the angle based on the current heading
        let headingToMecca = angleToMecca - currentHeading
        return headingToMecca
    }
    
    func calculateBearingBetweenPoints(fromLatitude: Double, fromLongitude: Double, toLatitude: Double, toLongitude: Double ) -> Double {
        let deltaLongitude = toLongitude - fromLongitude
        let y = sin(deltaLongitude) * cos(toLatitude)
        let x = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(deltaLongitude)
        let bearing = atan2(y, x)
        return (bearing * 180 / .pi + 360).truncatingRemainder(dividingBy: 360)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
}



#Preview {
    CompassView()
}

//
//  LearningView.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/05/12.
//

import SwiftUI

struct LearningView: View {
    @State private var randomIndex = Int.random(in: 0..<Context.shared.motivational_ayats.count)
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
                    Text("Motivational Ayats ").padding(.top,45)
                        .font(.system(size: 26))
                        .bold()
                        .foregroundStyle(.orange)
                }
                Text("Tap on the ayat to change them. You can scroll the text.")
                    .bold().padding(.bottom,50)
                Image(systemName: "book.fill").font(.system(size: 90))
                    .bold().padding(.bottom,50)
                ScrollView{
                    Text(Context.shared.motivational_ayats[randomIndex][0]).font(.system(size: 22))
                        .padding()
                        .foregroundStyle(.orange)
                    Text(Context.shared.motivational_ayats[randomIndex][1]).font(.system(size: 21))
                        .padding()
                    Text("It's a product of BIENG HALAL. Please pray for us. Share this app with others and Give us a feedback on Appstore.")
                        .padding()
                        .foregroundStyle(.gray)
                }
                Spacer()
            }
            .onTapGesture {
                randomIndex = Int.random(in: 0..<Context.shared.motivational_ayats.count)
            }
        }
    }
}

#Preview {
    LearningView().preferredColorScheme(.dark)
}

//
//  ContentView.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI

struct ConnectedView: View {
    @EnvironmentObject var connectionState: ConnectingStateViewModel
    @State var rect: CGRect = .zero
    @State var runAnimation = true

    var body: some View {
        ZStack {
            sunnyView
                .offset(x: connectionState.isMuted ? rect.width : 0)
                .animation(.easeInOut(duration: 0.5))
            nightView
                .offset(x: connectionState.isMuted ? 0 : -rect.width)
                .animation(.easeInOut(duration: 0.5))

            VStack {
                Image(connectionState.isMuted ? "Muted" : "Listening")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .overlay(Image(systemName: connectionState.isMuted ? "mic.slash.fill" : "mic.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                    )
                    .onTapGesture {
                        connectionState.state = connectionState.state == .muted ? .unmuted : .muted
                    }
                    .padding(.top, 50)
                    .animation(.easeInOut)

                Spacer()
                
                LottieViewKeyframed(filename: "birdie", loopingSectionFrames: (80, 35), isConcludedLoopingFrames: (80, 100), isUp: $connectionState.isMuted)
                    .frame(width: 300, height: 300)
            }
            .padding(.vertical, 20)
        }
        .background(GeometryGetter(rect: $rect))
    }
    
    var sunnyView: some View {
        Group {
            VStack {
                HStack {
                    Spacer()
                    LottieViewRepeated(filename: "sunny", loopMode: .loop)
                        .frame(width: 140, height: 140)
                        .animation(.easeInOut)
                }
                .padding(.all, 10)
                
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: 0x775252), Color(hex: 0xFFCA6D)]), startPoint: UnitPoint(x: 0, y: 0.5), endPoint: UnitPoint(x: 1, y: 0.3)).edgesIgnoringSafeArea(.all))
        }
    }
    
    var nightView: some View {
        Group {
            VStack {
                HStack {
                    LottieViewRepeated(filename: "night", loopMode: .loop)
                        .frame(width: 140, height: 140)
                        .animation(.easeInOut)
                    Spacer()
                }
                .padding(.all, 10)
                
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: 0x0F053F), Color(hex: 0xAF7D5D)]), startPoint: UnitPoint(x: 0.0, y: 0.3), endPoint: UnitPoint(x: 1.5, y: 0.8)).edgesIgnoringSafeArea(.all))

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedView()
    }
}

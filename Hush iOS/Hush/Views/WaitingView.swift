//
//  WaitingView.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        VStack {
            Text("Searching for connection")
                .bold()
                .font(.system(size: 22, weight: .bold, design: .default))
            
            LottieViewRepeated(filename: "ripples",
                               loopMode: .loop)
        }
        .padding(.all, 20)
        .padding(.vertical, 30)
    }
}

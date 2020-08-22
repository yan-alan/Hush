//
//  WaitingView.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Searching for connection")
                .bold()
                .font(.system(size: 22, weight: .bold, design: .default))
            LottieViewRepeated(filename: "ripples", loopMode: .loop)
                .frame(width: 350, height: 350)
                .clipped()
        }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
    }
}

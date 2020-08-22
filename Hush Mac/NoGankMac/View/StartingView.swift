//
//  StartingView.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI

struct StartingView: View {
    @EnvironmentObject var connectionState: ConnectingStateViewModel
    var body: some View {
        if connectionState.state == .waiting {
            WaitingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if connectionState.state == .muted || connectionState.state == .unmuted {
            ConnectedView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text("Failed")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

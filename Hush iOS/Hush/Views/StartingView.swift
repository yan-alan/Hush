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
        } else if connectionState.state == .connected {
            ConnectedView()
        } else {
            Text("Failed")
        }
    }
}

//
//  No_GankApp.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI

@main
struct No_GankApp: App {
    var body: some Scene {
        WindowGroup {
            StartingView().environmentObject(ConnectingStateViewModel.shared)
        }
    }
}

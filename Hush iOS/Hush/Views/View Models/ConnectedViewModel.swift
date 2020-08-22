//
//  ConnectedViewModel.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI
import CoreMotion

class ConnectedViewModel: ObservableObject {
    @Published var isSendable: Bool = false

    var motionManager: CMMotionManager
    init() {
        motionManager = CMMotionManager()
        startPollingForAccelerometer()
    }
    
    private func startPollingForAccelerometer() {
        let queue = OperationQueue()
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: queue) { [self] (data, error) in
                guard self.isSendable else { return }
                guard error == nil else {
                    print(error!)
                    return
                }
                
                if let newAcc = data?.rotationRate {
                    var sum: Double = 0


                    sum = abs(newAcc.x) + abs(newAcc.y) + abs(newAcc.z)
                    print(sum)
                    if sum > 0.3 {
                        ConnectingStateViewModel.shared.mcHelper.sendToAllPeers("MIC".data(using: .utf8)!, reliably: true)
                    }
                }
            }
        }
    }
}

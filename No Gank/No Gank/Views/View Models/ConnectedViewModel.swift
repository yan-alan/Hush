//
//  ConnectedViewModel.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI
import CoreMotion

class ConnectedViewModel: ObservableObject {
    @Published var acceleration: CMAcceleration = .init(x: 0, y: 0, z: 0)
    @Published var isSendable: Bool = false

    var motionManager: CMMotionManager
    init() {
        motionManager = CMMotionManager()
        startPollingForAccelerometer()
    }
    
    private func startPollingForAccelerometer() {
        let queue = OperationQueue()
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: queue) { (data, error) in
                guard self.isSendable else { return }
                guard error == nil else {
                    print(error!)
                    return
                }
                
                if let newAcc = data?.acceleration {
                    if abs((self.acceleration.x + self.acceleration.y + self.acceleration.z) - (newAcc.x + newAcc.y + newAcc.z)) > 0.2 {
                        ConnectingStateViewModel.shared.mcHelper.sendToAllPeers("MIC".data(using: .utf8)!, reliably: true)
                    }
                    DispatchQueue.main.async {
                        self.acceleration = newAcc
                    }
                }
            }
        }
    }
}

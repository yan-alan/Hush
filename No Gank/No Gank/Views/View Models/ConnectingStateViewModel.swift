//
//  ConnectingStateViewModel.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import Foundation
import MultipeerConnectivity

class ConnectingStateViewModel: ObservableObject {
    static let shared = ConnectingStateViewModel()
    let mcHelper = MultipeerHelper(serviceName: "nogank")
    @Published var state: State = .waiting
    
    private init() {
        mcHelper.delegate = self
    }
    
    enum State {
        case waiting
        case failed
        case connected
    }
}

extension ConnectingStateViewModel: MultipeerHelperDelegate {
    func shouldAcceptJoinRequest(peerID: MCPeerID, context: Data?) -> Bool {
        return true
    }
    func shouldSendJoinRequest(_ peer: MCPeerID) -> Bool {
        return true
    }
    func peerJoined(_ peer: MCPeerID) {
        DispatchQueue.main.async {
            self.state = .connected
        }
    }
}

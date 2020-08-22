//
//  ConnectingStateViewModel.swift
//  No Gank
//
//  Created by Alan Yan on 2020-08-21.
//

import Foundation
import MultipeerConnectivity
import Combine

class ConnectingStateViewModel: ObservableObject {
    let mcHelper = MultipeerHelper(serviceName: "nogank")
    @Published var state: State = .waiting
    @Published var isMuted: Bool = false
    
    @Published var scale: CGFloat = 1
    var cancellable: AnyCancellable?
    init() {
        print("multipeer stuff")
        mcHelper.delegate = self
        
        cancellable = $state.receive(on: DispatchQueue.main).sink(receiveValue: { value in
            if value == .muted {
                print("Is Muted")
                self.isMuted = true
                self.runMuteScript(input: 0)
                self.sendToSlack()
            } else if value == .unmuted {
                print("Is Not Muted")
                self.isMuted = false
                self.runMuteScript(input: 100)
            }
        })
        
    }
    
    private func runMuteScript(input: Int) {
        var error: NSDictionary?
        let appleScript = "set volume input volume \(input)"
        if let script = NSAppleScript(source: appleScript) {
            _ = script.executeAndReturnError(&error)
        }
    }
    
    private func sendToSlack() {
        guard let url = URL(string: "https://gareth-moose.api.stdlib.com/ganked@dev/") else { return }
        var urlReq = URLRequest(url: url)
        urlReq.allHTTPHeaderFields = [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
        urlReq.httpMethod = "POST"
        
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "h:mm:ss a"
        print(formatter.string(from: Date()))
        URLDataTask.completeDataTask(req: urlReq, body: ["firstName" : "Gareth", "lastName" : "Lau", "formattedTime" :         formatter.string(from: Date())]) { (err) in
            if let error = err {
                print(error)
            }
        }
    }
    enum State {
        case waiting
        case failed
        case muted
        case unmuted
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
            self.state = .unmuted
        }
    }
    func peerLeft(_ peer: MCPeerID) {
        print("Peer left")
//        DispatchQueue.main.async {
//            self.state = .waiting
//        }
    }
    func peerLost(_ peer: MCPeerID) {
        print("Peer lost")
        DispatchQueue.main.async {
            self.state = .waiting
        }
    }
    func receivedData(_ data: Data, _ peer: MCPeerID) {
        guard self.state != .muted else { return }
        print(data.base64EncodedString())
        DispatchQueue.main.sync {
            self.state = .muted
        }
    }
}

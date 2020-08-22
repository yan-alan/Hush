//
//  MultipeerHelper.swift
//  NoGankMac
//
//  Created by Alan Yan on 2020-08-21.
//
import SwiftUI
import MultipeerConnectivity

public class MultipeerHelper: NSObject {
    /// What type of session you want to make.
    ///
    /// `both` creates a session where all users are equal
    /// Otherwise if you want one specific user to be the host, choose `host` and `peer`
    public enum SessionType: Int {
        case host = 1
        case peer = 2
        case both = 3
    }
    
    public let sessionType: SessionType
    public let serviceName: String
    
    public let myPeerID = MCPeerID(displayName: UUID().uuidString)
    public private(set) var session: MCSession!
    public private(set) var serviceAdvertiser: MCNearbyServiceAdvertiser?
    public private(set) var serviceBrowser: MCNearbyServiceBrowser?
    
    public weak var delegate: MultipeerHelperDelegate?
    
    /// - Parameters:
    ///   - serviceName: name of the service to be added, must be less than 15 lowercase ascii characters
    ///   - sessionType: Type of session (host, peer, both)
    ///   - delegate: optional `MultipeerHelperDelegate` for MultipeerConnectivity callbacks
    public init(
        serviceName: String,
        sessionType: SessionType = .both,
        delegate: MultipeerHelperDelegate? = nil
    ) {
        self.serviceName = serviceName
        self.sessionType = sessionType
        self.delegate = delegate
        
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        if (self.sessionType.rawValue & SessionType.host.rawValue) != 0 {
            serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: self.serviceName)
            serviceAdvertiser?.delegate = self
            serviceAdvertiser?.startAdvertisingPeer()
        }
        
        if (self.sessionType.rawValue & SessionType.peer.rawValue) != 0 {
            serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: self.serviceName)
            serviceBrowser?.delegate = self
            serviceBrowser?.startBrowsingForPeers()
        }
    }
    
    @discardableResult
    public func sendToAllPeers(_ data: Data, reliably: Bool) -> Bool {
        return sendToPeers(data, reliably: reliably, peers: connectedPeers)
    }
    
    @discardableResult
    public func sendToPeers(_ data: Data, reliably: Bool, peers: [MCPeerID]) -> Bool {
        guard !peers.isEmpty else { return false }
        do {
            try session.send(data, toPeers: peers, with: reliably ? .reliable : .unreliable)
        } catch {
            print("error sending data to peers \(peers): \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    public var connectedPeers: [MCPeerID] {
        session.connectedPeers
    }
}

extension MultipeerHelper: MCSessionDelegate {
    public func session(
        _: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        if state == .connected {
            delegate?.peerJoined?(peerID)
        } else if state == .notConnected {
            delegate?.peerLeft?(peerID)
        }
    }
    
    public func session(_: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.receivedData?(data, peerID)
    }
    
    public func session(
        _: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        delegate?.receivedStream?(stream, streamName, peerID)
    }
    
    public func session(
        _: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        delegate?.receivingResource?(resourceName, peerID, progress)
    }
    
    public func session(
        _: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: Error?
    ) {
        delegate?.receivedResource?(resourceName, peerID, localURL, error)
    }
}

extension MultipeerHelper: MCNearbyServiceBrowserDelegate {
    /// - Tag: SendPeerInvite
    public func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo _: [String: String]?
    ) {
        // Ask the handler whether we should invite this peer or not
        guard session.connectedPeers.count == 0 else { return }
        if delegate?.shouldSendJoinRequest == nil || (delegate?.shouldSendJoinRequest?(peerID) ?? false) {
            print("BrowserDelegate \(peerID)")
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        }
    }
    
    public func browser(_: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.peerLost?(peerID)
    }
}

extension MultipeerHelper: MCNearbyServiceAdvertiserDelegate {
    /// - Tag: AcceptInvite
    public func advertiser(
        _: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext data: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        // Call the handler to accept the peer's invitation to join.
        
        guard session.connectedPeers.count == 0 else { return }
        let shouldAccept = self.delegate?.shouldAcceptJoinRequest?(peerID: peerID, context: data)
        invitationHandler(shouldAccept != nil ? shouldAccept! : true, self.session)
    }
}


import MultipeerConnectivity

@objc public protocol MultipeerHelperDelegate: AnyObject {
    /// Data that has been recieved from another peer
    /// - Parameters:
    ///     - data: The data which has been recieved
    ///     - peer: The peer that sent the data
    @objc optional func receivedData(_ data: Data, _ peer: MCPeerID)
    
    /// Callback for when a peer joins the network
    /// - Parameter peer: the   `MCPeerID` of the newly joined peer
    @objc optional func peerJoined(_ peer: MCPeerID)
    
    /// Callback for when a peer leaves the network
    /// - Parameter peer: the   `MCPeerID` of the peer that left
    @objc optional func peerLeft(_ peer: MCPeerID)
    
    /// Callback for when a new peer has been found. will default to accept all peers
    /// - Parameter peer: the   `MCPeerID` of the peer who wants to join the network
    /// - Returns: Bool if the peer request to join the network or not
    @objc optional func shouldSendJoinRequest(_ peer: MCPeerID) -> Bool
    
    /// Handle when a peer has requested to join the network
    /// - Parameters:
    ///   - peerID: Peer requesting to join
    ///   - context: Any data the requesting peer may have sent with their request
    /// - Returns: Bool if the peer's join request should be accepted
    @objc optional func shouldAcceptJoinRequest(peerID: MCPeerID, context: Data?) -> Bool
    
    /// Peer can no longer be found on the network, and thus cannot receive data
    /// - Parameter peer: If a peer has left the network in a non typical way
    @objc optional func peerLost(_ peer: MCPeerID)
    @objc optional func receivedStream(_ stream: InputStream, _ streamName: String, _ peer: MCPeerID)
    @objc optional func receivingResource(_ resourceName: String, _ peer: MCPeerID, _ progress: Progress)
    @objc optional func receivedResource(_ resourceName: String, _ peer: MCPeerID, _ url: URL?, _ error: Error?)
}

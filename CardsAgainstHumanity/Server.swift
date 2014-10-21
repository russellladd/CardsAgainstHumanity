//
//  Server.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/19/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ServerDelegate: class {
    
    func server(server: Server, didNotStartAdvertisingWithError error: NSError)
    func server(server: Server, didAddPlayer player: MCPeerID)
}

class Server: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        session.delegate = self
        advertiser.delegate = self
    }
    
    // MARK: Delegate
    
    weak var delegate: ServerDelegate?
    
    // MARK: Advertiser
    
    let advertiser = MCNearbyServiceAdvertiser(peer: DevicePeerID, discoveryInfo: DeviceDiscoveryInfo, serviceType: ServiceType)
    
    // MARK: Advertiser delegate
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        delegate?.server(self, didNotStartAdvertisingWithError: error)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        invitationHandler(true, session)
    }
    
    // MARK: Peers
    
    var players = [MCPeerID]()
    
    // MARK: Session
    
    let session = MCSession(peer: DevicePeerID)
    
    // MARK: Peer management
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            if state == .Connected {
                
                if find(self.players, peerID) == nil {
                    
                    self.players += [peerID]
                    self.delegate?.server(self, didAddPlayer: peerID)
                }
            }
        }
    }
    
    // MARK: Receiving data
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    // MARK: Sending data
    
    func sendCards(cards: [WhiteCardID], toPlayer player: MCPeerID) {
        
        var message = [String: AnyObject]()
        
        message["type"] = "drawCards"
        message["whiteCardIDs"] = cards
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(message)
        
        session.sendData(data, toPeers: [player], withMode: .Reliable, error: nil)
    }
}

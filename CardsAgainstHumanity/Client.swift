//
//  Client.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ConnectionDelegate: class {
    
    func clientFailedToConnectToServer(client: Client)
    func clientDidConnectToServer(client: Client)
    func clientDidDisconnectFromServer(client: Client)
}

protocol GameDelegate: class {
    
    func client(client: Client, didReceiveWhiteCards cards: [WhiteCardID])
}

class Client: NSObject, MCSessionDelegate {
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        session.delegate = self
    }
    
    // MARK: Delegates
    
    weak var connectionDelegate: ConnectionDelegate?
    weak var gameDelegate: GameDelegate?
    
    // MARK: Peers
    
    var connectingServerPeerID: MCPeerID?
    var serverPeerID: MCPeerID?
    
    var playersByPeerID = [DevicePeerID: Player(name: UIDevice.currentDevice().name)]
    
    var myPlayer: Player {
        return playersByPeerID[DevicePeerID]!
    }
    
    // MARK: Session
    
    let session = MCSession(peer: DevicePeerID)
    
    // MARK: Peer management
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            if state != .Connecting {
                
                if peerID == self.connectingServerPeerID {
                    
                    self.connectingServerPeerID = nil
                    
                    if state == .NotConnected {
                        self.connectionDelegate?.clientFailedToConnectToServer(self)
                    } else if state == .Connected {
                        self.serverPeerID = peerID
                        self.connectionDelegate?.clientDidConnectToServer(self)
                    }
                    
                } else if peerID == self.serverPeerID {
                    
                    if state == .NotConnected {
                        self.serverPeerID = nil
                        self.connectionDelegate?.clientDidDisconnectFromServer(self)
                    }
                }
            }
        }
    }
    
    // MARK: Receiving data
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            
            let message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [String: AnyObject]
            
            let type = message["type"]! as String
            
            switch type {
                
            case "drawCards":
                let whiteCards = message["whiteCardIDs"]! as [WhiteCardID]
                println("Received cards: \(whiteCards)")
                self.gameDelegate?.client(self, didReceiveWhiteCards: whiteCards)
                
            default:
                println("Unknown message")
            }
        }
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    // MARK: Sending data
    
    
}

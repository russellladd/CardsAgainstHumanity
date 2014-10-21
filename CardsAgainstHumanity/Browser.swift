//
//  Browser.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct Device {
    
    let peerID: MCPeerID
    let type: UIUserInterfaceIdiom
    let name: String
}

protocol BrowserDelegate: class {
    
    func browser(browser: Browser, didNotStartBrowsingError error: NSError)
    func browser(browser: Browser, insertDeviceAtIndex index: Int)
    func browser(browser: Browser, deleteDeviceAtIndex index: Int)
}

class Browser: NSObject, MCNearbyServiceBrowserDelegate {
    
    // MARK: Initialization
    
    init(session: MCSession, deviceType: UIUserInterfaceIdiom) {
        
        self.session = session
        
        super.init()
        
        browser.delegate = self
        
        browser.startBrowsingForPeers()
    }
    
    deinit {
        
        browser.stopBrowsingForPeers()
    }
    
    // MARK: Delegate
    
    weak var delegate: BrowserDelegate?
    
    // MARK: Session
    
    let session: MCSession
    
    // MARK: Discovered devices
    
    var discoveredDevices = [Device]()
    
    // MARK: Browser
    
    let browser = MCNearbyServiceBrowser(peer: DevicePeerID, serviceType: ServiceType)
    
    func inviteDevice(device: Device) {
        
        browser.invitePeer(device.peerID, toSession: session, withContext: nil, timeout: 15.0)
    }
    
    // MARK: Browser delegate
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        delegate?.browser(self, didNotStartBrowsingError: error)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        
        if let dictionary = info as? [String: String] {
            
            var type = UIUserInterfaceIdiom.Unspecified
            
            switch dictionary["deviceType"]! {
            case "Phone":
                type = .Phone
            case "Pad":
                type = .Pad
            default:
                ()
            }
            
            let device = Device(peerID: peerID, type: type, name: dictionary["deviceName"]!)
            
            discoveredDevices += [device]
            delegate?.browser(self, insertDeviceAtIndex: discoveredDevices.count - 1)
        }
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        
        var index: Int?
        for i in 0..<discoveredDevices.count {
            if discoveredDevices[i].peerID == peerID {
                index = i
                break;
            }
        }
        
        if let index = index {
            discoveredDevices.removeAtIndex(index)
            delegate?.browser(self, deleteDeviceAtIndex: index)
        }
    }
}

//
//  Service.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/19/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation
import MultipeerConnectivity

let ServiceType = "grl5-cah"

let DevicePeerID: MCPeerID = {
    
    let peerIDKey = "peerID"
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if let peerData = defaults.objectForKey(peerIDKey) as? NSData {
        
        return NSKeyedUnarchiver.unarchiveObjectWithData(peerData) as MCPeerID
        
    } else {
        
        let uuid = UIDevice.currentDevice().identifierForVendor
        
        let peer = MCPeerID(displayName: uuid.UUIDString)
        
        let peerData = NSKeyedArchiver.archivedDataWithRootObject(peer)
        defaults.setObject(peerData, forKey: peerIDKey)
        
        return peer;
    }
}()

let DeviceDiscoveryInfo: [String: String] = {
    
    var deviceType = "None"
    
    switch UIScreen.mainScreen().traitCollection.userInterfaceIdiom {
    case .Phone:
        deviceType = "Phone"
    case .Pad:
        deviceType = "Pad"
    default:
        assertionFailure("Device must be phone or pad")
    }
    
    var deviceName = UIDevice.currentDevice().name
    
    return ["deviceType": deviceType, "deviceName": deviceName]
}()

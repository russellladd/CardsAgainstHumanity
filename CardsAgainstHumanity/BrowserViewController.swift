//
//  BrowserViewController.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@objc protocol BrowserViewControllerDelegate: class {
    
    func browserViewControllerDidCancel(browserViewController: BrowserViewController)
}

class BrowserViewController: UICollectionViewController, BrowserDelegate, ConnectionDelegate {
    
    // MARK: Initializer
    
    required init(coder aDecoder: NSCoder) {
        
        browser = Browser(session: client.session, deviceType: .Pad)
        
        super.init(coder: aDecoder)
        
        client.connectionDelegate = self
        browser.delegate = self
    }
    
    // MARK: Delegate
    
    var delegate: BrowserViewControllerDelegate?
    
    // MARK: Client
    
    let client: Client = Client()
    
    // MARK: Game change observer
    
    func clientFailedToConnectToServer(client: Client) {
        
        let alert = UIAlertController(title: "Unable to Connect", message: "That iPad is whack.", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.choosingIndexPath = nil
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func clientDidConnectToServer(client: Client) {
        
        performSegueWithIdentifier("showHand", sender: nil)
    }
    
    func clientDidDisconnectFromServer(client: Client) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Browser
    
    let browser: Browser
    
    // MARK: Browser delegate

    func browser(browser: Browser, didNotStartBrowsingError error: NSError) {
        
        let alert = UIAlertController(title: "Unable to Browse", message: "Your peer-to-peer hardware is broken. Ouch.", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.delegate?.browserViewControllerDidCancel(self)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func browser(browser: Browser, insertDeviceAtIndex index: Int) {
        collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
    }
    
    func browser(browser: Browser, deleteDeviceAtIndex index: Int) {
        collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
    }
    
    // MARK: Choosing index path
    
    var choosingIndexPath: NSIndexPath? {
        didSet {
            
            if let oldValue = oldValue {
                
                let cell = collectionView!.cellForItemAtIndexPath(oldValue) as DeviceCell
                
                cell.button.hidden = false
                cell.activityIndicatorView.stopAnimating()
                
                collectionView!.scrollEnabled = true
            }
            
            if let newValue = choosingIndexPath {
                
                let cell = collectionView!.cellForItemAtIndexPath(newValue) as DeviceCell
                
                cell.button.hidden = true
                cell.activityIndicatorView.startAnimating()
                
                collectionView!.scrollEnabled = false
            }
        }
    }
    
    // MARK: View life cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = collectionView!.collectionViewLayout as UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(collectionView!.bounds.width, 400.0)
    }
    
    // MARK: Cancel button action
    
    @IBAction func cancelBarButtonItemAction() {
        delegate?.browserViewControllerDidCancel(self)
    }
    
    // MARK: Collection view data source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return browser.discoveredDevices.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Device Cell", forIndexPath: indexPath) as DeviceCell
        
        let device = browser.discoveredDevices[indexPath.item]
        
        cell.label.text = device.name
        
        return cell
    }
    
    // MARK: Choose button action
    
    @IBAction func chooseButtonTouchUpInside(button: UIButton) {
        
        let buttonCenter = collectionView!.convertPoint(button.center, fromView: button.superview)
        let indexPath = collectionView!.indexPathForItemAtPoint(buttonCenter)!
        
        choosingIndexPath = indexPath
        
        client.connectingServerPeerID = browser.discoveredDevices[choosingIndexPath!.item].peerID
        
        browser.inviteDevice(browser.discoveredDevices[indexPath.item])
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showHand" {
            
            let viewController = segue.destinationViewController as HandViewController
        }
    }
}

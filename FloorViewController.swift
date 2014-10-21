//
//  Floor.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol FloorViewControllerDelegate {
    
    func floorViewControllerDidQuit(floorViewController: FloorViewController)
}

class FloorViewController: UICollectionViewController, ServerDelegate {
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        
        remainingWhiteCards = map(0..<Deck.sharedDeck.whiteCards.count) { WhiteCardID(id: $0) }
        
        super.init(coder: aDecoder)
        
        server.delegate = self
    }
    
    // MARK: Game
    
    var remainingWhiteCards: [WhiteCardID]
    
    // MARK: Cards
    
    let cards = Deck.sharedDeck.whiteCards
    
    var cardsFaceUp = [Bool](count: Deck.sharedDeck.whiteCards.count, repeatedValue: false)
    
    // MARK: Delegate
    
    var delegate: FloorViewControllerDelegate?
    
    // MARK: Server
    
    let server = Server()
    
    // MARK: Server delegate
    
    func server(server: Server, didNotStartAdvertisingWithError error: NSError) {
        
        let alert = UIAlertController(title: "Unable to Advertise", message: "Your peer-to-peer hardware is broken. Ouch.", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.delegate?.floorViewControllerDidQuit(self)
            ()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func server(server: Server, didAddPlayer player: MCPeerID) {
        
        var cardsToSend = [WhiteCardID]()
        
        for i in 0..<3 {
            
            let index = Int(arc4random() % UInt32(remainingWhiteCards.count))
            cardsToSend += [remainingWhiteCards.removeAtIndex(index)]
        }
        
        server.sendCards(cardsToSend, toPlayer: player)
    }
    
    // MARK: Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.allowsSelection = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        server.advertiser.startAdvertisingPeer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        server.advertiser.stopAdvertisingPeer()
    }
    
    // MARK: Collection view data source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Card Cell", forIndexPath: indexPath) as CardCell
        
        cell.textLabel.text = cards[indexPath.item].text
        cell.faceUp = cardsFaceUp[indexPath.item]
        
        return cell
    }
    
    // MARK: Collection view delegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        cardsFaceUp[indexPath.item] = !cardsFaceUp[indexPath.item]
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CardCell
        cell.setFaceUp(cardsFaceUp[indexPath.item], animated: true)
    }
}

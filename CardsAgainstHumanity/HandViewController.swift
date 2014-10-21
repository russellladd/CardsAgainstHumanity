//
//  Hand.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

class HandViewController: UIViewController, GameDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Client
    
    var client: Client! {
        didSet {
            client.gameDelegate = self
        }
    }
    
    // MARK: Game delegate
    
    func client(client: Client, didReceiveWhiteCards cards: [WhiteCardID]) {
        
        println("Recieved cards: \(cards)")
    }
    
    // MARK: Model
    
    var cards = Deck.sharedDeck.whiteCards
    
    func submitCardAtIndex(index: Int) {
        
        cards.removeAtIndex(index)
        
        collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
    }
    
    // MARK: Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return hideStatusBar
    }
    
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: Collection view
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Collection view data source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Card Cell", forIndexPath: indexPath) as CardCell
        
        cell.textLabel.text = cards[indexPath.item].text
        
        return cell
    }
    
    // MARK: Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView != collectionView {
            
            // Get layout and index path
            
            let layout = collectionView.collectionViewLayout as HandLayout
            
            let indexPath = (collectionView.indexPathsForVisibleItems() as [NSIndexPath]).filter { indexPath in
                return (self.collectionView.cellForItemAtIndexPath(indexPath) as CardCell).scrollView == scrollView
            }.first!
            
            // Hide status bar when card is occluding it
            
            let cardView = (collectionView.cellForItemAtIndexPath(indexPath) as CardCell).cardView
            
            let cardViewRect = cardView.convertRect(cardView.bounds, toView: self.view)
            
            UIView.animateWithDuration(0.25) {
                self.hideStatusBar = (cardViewRect.minY < 20.0 && cardViewRect.maxY > 0.0)
            }
            
            // Scrunch hand layout if pulling down
            
            if scrollView.contentOffset.y < 0.0 {
                
                layout.pulledCardIndexPath = indexPath
                layout.pulledCardOffset = -scrollView.contentOffset.y
                
            } else if scrollView.contentOffset.y == 0.0 {
                
                layout.pulledCardIndexPath = nil
                layout.pulledCardOffset = 0.0
            }
            
            // Submit card if slid up
            
            if scrollView.bounds.maxY == scrollView.contentSize.height {
                submitCardAtIndex(indexPath.item)
            }
        }
    }
}

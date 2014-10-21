//
//  Deck.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

struct BlackCard {
    
    let text: String
}

struct WhiteCard {
    
    let text: String
}

struct Deck {
    
    static let sharedDeck = Deck()
    
    let blackCards: [BlackCard]
    let whiteCards: [WhiteCard]
    
    private init() {
        
        let url = NSBundle.mainBundle().URLForResource("Cards", withExtension: "plist")!
        
        let dictionary = NSDictionary(contentsOfURL: url)
        
        blackCards = map(dictionary["Black Cards"] as [String]) { text in
            return BlackCard(text: text)
        }
        
        whiteCards = map(dictionary["White Cards"] as [String]) { text in
            return WhiteCard(text: text)
        }
    }
}

//
//  Game.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import Foundation

struct BlackCardID {
    
    let id: Int
    
    var card: BlackCard {
        return Deck.sharedDeck.blackCards[id]
    }
}

class WhiteCardID: NSObject, NSCoding {
    
    init(id: Int) {
        self.id = id
    }
    
    let id: Int
    
    var card: WhiteCard {
        return Deck.sharedDeck.whiteCards[id]
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: "id")
    }
}

struct Player {
    
    static let baseHandSize = 3
    
    let name: String
    
    var hand: [WhiteCardID] = []
    
    var submittedCard: WhiteCardID?
    
    var winningPairs: [Pair] = []
    
    init(name: String) {
        self.name = name
    }
}

struct Pair {
    
    let blackCard: BlackCardID
    let whiteCard: WhiteCardID
}

struct Game {
    
    var players: [Player] = []
    
    var cardCzar: Player?
    var currentBlackCardID: BlackCardID?

    var remainingBlackCardIDs: [BlackCardID]
    var remainingWhiteCardIDs: [WhiteCardID]
    
    init() {
        
        remainingBlackCardIDs = map(0..<Deck.sharedDeck.blackCards.count) { BlackCardID(id: $0) }
        remainingWhiteCardIDs = map(0..<Deck.sharedDeck.whiteCards.count) { WhiteCardID(id: $0) }
    }
    
    mutating func addPlayerWithName(name: String) {
        
        players += [Player(name: name)]
        
        fillHandForPlayerAtIndex(players.count - 1)
    }
    
    mutating func drawBlackCard() {
        
        let index = Int(arc4random() % UInt32(remainingBlackCardIDs.count))
        
        currentBlackCardID = remainingBlackCardIDs.removeAtIndex(index)
    }
    
    mutating func drawWhiteCardForPlayerAtIndex(index: Int) {
        
        let index = Int(arc4random() % UInt32(remainingWhiteCardIDs.count))
        
        players[index].hand += [remainingWhiteCardIDs.removeAtIndex(index)]
    }
    
    mutating func fillHandForPlayerAtIndex(index: Int) {
        
        while players[index].hand.count < Player.baseHandSize {
            drawWhiteCardForPlayerAtIndex(index)
        }
    }
}

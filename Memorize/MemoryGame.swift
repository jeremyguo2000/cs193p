//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/25/24.
//

import Foundation

// This is the Model
struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        // add 2*numberOfPairsOfCards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    struct Card {
        // part of MemoryGame namespace
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
        
    }
    
}

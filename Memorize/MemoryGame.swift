//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/25/24.
//

import Foundation

struct MemoryGame<CardContent> {
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        // add 2*numberOfPairsOfCards
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(isFaceUp: false, isMatched: false, content: content))
            cards.append(Card(isFaceUp: false, isMatched: false, content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    struct Card {
        // part of MemoryGame namespace
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
        
    }
    
}

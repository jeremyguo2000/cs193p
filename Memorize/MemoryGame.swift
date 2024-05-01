//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/25/24.
//

import Foundation
import SwiftUI

// This is the Model

// CardContent must conform to equatable
struct MemoryGame<CardContent> where CardContent : Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, allThemeEmoji: [String], cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        // randomly select cards from all emoji for the theme
        let indices = Array((0..<max(2,allThemeEmoji.count)).shuffled().prefix(numberOfPairsOfCards))
        
        // add 2*numberOfPairsOfCards
        for pairIndex in indices {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    
    mutating func choose(_ card: Card) {
        print("chose \(card)")
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                
                // this branch is when there's already one face up card
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    } else {
                        // no match, must be penalized if we have seen this
                        score -= (cards[chosenIndex].isSeen ? 1 : 0) + (cards[potentialMatchIndex].isSeen ? 1 : 0)

                        
                        // future mismatches involving these cards are penalized
                        cards[chosenIndex].isSeen = true
                        cards[potentialMatchIndex].isSeen = true
                    }
                } else {
                    // this branch is when there's 0 or already 2 face up cards
                    // turns everything other than the selected card face down
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
                
                
            }
            
        }
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        // this sets the selected card to face up, all others to face down
        set { cards.indices.forEach {cards[$0].isFaceUp = (newValue == $0)} }
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : " ") "
        }
        
        // part of MemoryGame namespace
        var isFaceUp = false
        var isMatched = false
        var isSeen = false // whether the card has been previously seen
        let content: CardContent
        
        var id: String
        
    }
    
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

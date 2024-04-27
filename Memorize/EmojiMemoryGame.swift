//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/25/24.
//

import SwiftUI

// this is the ViewModel
class EmojiMemoryGame: ObservableObject {
    // namespaces inside class -> EmojiMemoryGame.emojis
    private static let emojis = ["🎃", "👻", "🦇", "🧛‍♂️", "🕷️", "🕸️", "🧟‍♂️", "🦴", "🍬", "🔮", "🧙‍♀️", "🌙"]
    
    private static func createMemoryGame() -> MemoryGame<String>{
        return MemoryGame<String>(numberOfPairsOfCards: 6) {pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
    // makes a change happen
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}

//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/25/24.
//

import SwiftUI

// this is the ViewModel
class EmojiMemoryGame: ObservableObject {
   
    struct ThemeData {
        let name: String
        let emoji: [String]
        let numPairs: Int
        let cardColor: Color
    }

    private static let themesData = [
        "furniture": ThemeData(name: "furniture", emoji:["🛋️", "🛏️", "🪑", "🚪", "🪞", "🪟"], numPairs: 6, cardColor: .green),
        "animals": ThemeData(name: "animals", emoji: ["🐶", "🐱", "🐭", "🐰", "🐻", "🐯"], numPairs: 5, cardColor: .red),
        "sports": ThemeData(name: "sports", emoji: ["⚽", "🏀", "🎾", "🏈", "🏓", "🏐"], numPairs: 4, cardColor: .orange),
        "food": ThemeData(name: "food", emoji: ["🍕", "🍔", "🍣", "🍝", "🍦", "🍰"], numPairs: 4, cardColor: .yellow),
        "flags": ThemeData(name: "flags", emoji: ["🇺🇸", "🇬🇧", "🇨🇦", "🇯🇵", "🇫🇷", "🇩🇪"], numPairs: 5, cardColor: .blue),
        "smileys": ThemeData(name: "smileys", emoji: ["😊", "😄", "😁", "😃", "😆", "😋"], numPairs: 6, cardColor: .purple)
    ]
    
    // TODO: why don't i need published on model?
    private var theme: ThemeData
    // @Published propagates changes to the UI i.e. the view
    @Published private var model: MemoryGame<String>
    
    init() {
        theme = EmojiMemoryGame.themesData.randomElement()!.value
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    // creates memory game and cards based on the theme
    // where is pairIndex coming from? --> MemoryGame
    private static func createMemoryGame(theme: ThemeData) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.numPairs, 
                                  allThemeEmoji: theme.emoji) { pairIndex in
            // this closure is the cardContentFactory, but it's only checking if it's inbounds
            if theme.emoji.indices.contains(pairIndex) {
                return theme.emoji[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        print("Starting new game!")
        theme = EmojiMemoryGame.themesData.randomElement()!.value
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func getThemeCardColor() -> Color {
        return theme.cardColor
    }
}

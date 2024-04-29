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

    // TODO: check the number of pairs thing (requirement number 7)
    
    private static let furnitureThemeData = ThemeData(name: "furniture", emoji:["🛋️", "🛏️", "🪑", "🚪", "🪞", "🪟"], numPairs: 6, cardColor: .green)
    private static let animalsThemeData = ThemeData(name: "animals", emoji: ["🐶", "🐱", "🐭", "🐰", "🐻", "🐯"], numPairs: 6, cardColor: .red)
    private static let sportsThemeData = ThemeData(name: "sports", emoji: ["⚽", "🏀", "🎾", "🏈", "🏓", "🏐"], numPairs: 6, cardColor: .orange)
    private static let foodThemeData = ThemeData(name: "food", emoji: ["🍕", "🍔", "🍣", "🍝", "🍦", "🍰"], numPairs: 6, cardColor: .yellow)
    private static let flagsThemeData = ThemeData(name: "flags", emoji: ["🇺🇸", "🇬🇧", "🇨🇦", "🇯🇵", "🇫🇷", "🇩🇪"], numPairs: 6, cardColor: .blue)
    private static let smileysThemeData = ThemeData(name: "smileys", emoji: ["😊", "😄", "😁", "😃", "😆", "😋"], numPairs: 6, cardColor: .purple)
    
    private static let themes = [furnitureThemeData, animalsThemeData, sportsThemeData, foodThemeData, flagsThemeData, smileysThemeData]
    
    // namespaces inside class -> EmojiMemoryGame.emojis
    // private static let emojis = ["🎃", "👻", "🦇", "🧛‍♂️", "🕷️", "🕸️", "🧟‍♂️", "🦴", "🍬", "🔮", "🧙‍♀️", "🌙"]
    
    // TODO: why don't i need published on model?
    private var theme: ThemeData
    // @Published propagates changes to the UI i.e. the view
    @Published private var model: MemoryGame<String>
    
    init() {
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    private static func createMemoryGame(theme: ThemeData) -> MemoryGame<String>{
        
        // theme = themes.randomElement()!
        return MemoryGame<String>(numberOfPairsOfCards: theme.numPairs) {pairIndex in
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
    
    // MARK: - Intents
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        print("Starting new game!")
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func getThemeCardColor() -> Color {
        return theme.cardColor
    }
}

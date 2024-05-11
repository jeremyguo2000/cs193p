//
//  SetModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import Foundation

struct SetGame<CardContent> {
    
    private(set) var cards: Array<Card>
    private(set) var numDealtCards: Int
    let numStartCards = 12
    let setSize = 3 // num cards in a set
    
    // TODO: what should be the behavior when cards are matched? should we
    // put them somewhere else?
    
    init(cardContentFactory: (Symbol, Shading, NumberOfSymbols, ElemColor) -> CardContent) {
        cards = []
        numDealtCards = numStartCards
        
        for symbol in Symbol.allCases {
            for shading in Shading.allCases {
                for numberOfSymbols in NumberOfSymbols.allCases {
                    for color in ElemColor.allCases {
                        let content = cardContentFactory(symbol, shading, numberOfSymbols, color)
                        let id =  "\(symbol.rawValue.prefix(2))_\(shading.rawValue.prefix(3))_\(numberOfSymbols.rawValue.prefix(3))_\(color.rawValue.prefix(2))"
                        let card = Card(content: content, id: id)
                        cards.append(card)
                    }
                }
            }
        }
        
        
        cards.shuffle()
        
        print(cards)
        print(cards.count)
        
    }
    
    
    // func for selecting cards
    mutating func choose(_ card: Card) {
        print("chose \(card)")

        // TODO: you should only be able to choose up to 3, so you need to keep track
        
        // TODO: i think this is fine for now since the card order might change after match
        // In Swift, structures, enumerations, and tuples are all value types.
        let chosenIndex = cards.firstIndex(where: {$0.id == card.id})
        cards[chosenIndex!].isSelected = !cards[chosenIndex!].isSelected
        
    }
    
    // func for dealing
    mutating func deal() {
        if numDealtCards < cards.count {
            numDealtCards += 3
        }
        print("numDealtCards \(numDealtCards)")
    }
    
    
    private mutating func shuffle() {
        cards.shuffle()
    }
    
    
    
    // struct for card
    // you manipulate cards here, but you don't need to care about the view
    struct Card: Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id)"
        }
        
        var isSelected = false
        let content: CardContent
        let id: String
    }
    
    // different selection states
    // blue -> selected, green -> 3 things form a set, red -> 3 things do not form a set
    // TODO: you need to keep track of how many cards are selected in total
    
    // support deselection
    
}

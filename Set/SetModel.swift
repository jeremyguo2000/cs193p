//
//  SetModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import Foundation


struct SetGame<CardContent> {
    
    private(set) var cards: Array<Card>
    
    init(cardContentFactory: (Symbol, Shading, NumberOfSymbols, Color) -> CardContent) {
        cards = []
        
        for symbol in Symbol.allCases {
            for shading in Shading.allCases {
                for numberOfSymbols in NumberOfSymbols.allCases {
                    for color in Color.allCases {
                        let content = cardContentFactory(symbol, shading, numberOfSymbols, color)
                        let id =  "\(symbol.rawValue)_\(shading.rawValue)_\(numberOfSymbols.rawValue)_\(color.rawValue)"
                        let card = Card(content: content, id: id)
                        cards.append(card)
                    }
                }
            }
        }
        
        print(cards)
        print(cards.count)
    
        
        // TODO: shuffle
    }
    
    
    // func for selecting cards
    
    
    // func for dealing
    
    
    
    // struct for card
    // you manipulate cards here, but you don't need to care about the view
    struct Card: CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id)"
        }
        
        var isSelected = false
        // TODO: what should CardContent be?
        let content: CardContent
        let id: String
    }
    
    
    // different selection states
    // blue -> selected, green -> 3 things form a set, red -> 3 things do not form a set
    // TODO: you need to keep track of how many cards are selected in total
    
    // support deselection
    
    
    // Set has a lot of instances of things with 3 states
    // TODO: color, shape, number, shading
    
}

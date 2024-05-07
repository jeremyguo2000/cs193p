//
//  SetViewModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI

// TODO: create all the cards here

// 4 features (symbol, number, shading, color), represent with enum --> 3^4 cards
// symbols: diamond, rectangle (squiggle), oval
// number: 1-3
// shading: empty, striped, fill
// color: green, blue, pink

enum Symbol: String, CaseIterable {
    case diamond
    case rectangle
    case oval
}

enum Shading: String, CaseIterable {
    case empty
    case stripe // can use semi-transparent instead
    case fill
}

enum NumberOfSymbols: String, CaseIterable {
    case ONE
    case TWO
    case THREE
}

enum Color: String, CaseIterable {
    case blue
    case yellow
    case purple
}

struct CardContent {
    let symbol: Symbol
    let shading: Shading
    let numberOfSymbols: NumberOfSymbols
    let color: Color
}

// deal 12 cards (at any point in time, there should always be 12 cards)
// keep finding sets until there are no more cards on the table

class SetViewModel: ObservableObject {
    
    @Published private var model: SetGame<CardContent>
    
    private static func createSetGame() -> SetGame<CardContent> {
        return SetGame() {symbol, shading, numberOfSymbols, color in
            // this is the closure
            return CardContent(symbol: symbol, shading: shading, numberOfSymbols: numberOfSymbols, color: color)
        }
    }
    
    init() {
        model = SetViewModel.createSetGame()
    }


    // deal 3 more cards
    func deal() {
        print("dealing ")
    }

    func newGame() {
        print("Starting a new game")
        model = SetViewModel.createSetGame()
    }

    func choose() {
        
    }

    
    
    
    
}


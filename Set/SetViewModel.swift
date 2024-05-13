//
//  SetViewModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI

enum Symbol: String, CaseIterable {
    case diamond // TODO: for now, represent this as a triangle
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
    
    func getNumSymbols() -> Int {
        switch self {
            case .ONE:
                return 1
            case .TWO:
                return 2
            case .THREE:
                return 3
        }
    }
}

enum ElemColor: String, CaseIterable {
    case blue
    case yellow
    case purple
}

struct CardContent {
    let symbol: Symbol
    let shading: Shading
    let numberOfSymbols: NumberOfSymbols
    let color: ElemColor
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
        model.deal()
    }

    func newGame() {
        print("Starting a new game")
        model = SetViewModel.createSetGame()
    }

    func choose(_ card: SetGame<CardContent>.Card) {
        model.choose(card)
    }
    
    func isValidSet() -> SetGame<CardContent>.chosenCardsState {
        // TODO: the model should be telling the shading
        // red? green? blue?
        return model.isSet()
    }

    var cards: Array<SetGame<CardContent>.Card> {
        let numDealt = model.numDealtCards
        return Array(model.cards.prefix(numDealt))
    }
    

    
    
    
}


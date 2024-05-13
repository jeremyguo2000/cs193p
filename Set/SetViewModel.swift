//
//  SetViewModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI



// deal 12 cards (at any point in time, there should always be 12 cards)
// keep finding sets until there are no more cards on the table

class SetViewModel: ObservableObject {
    
    @Published private var model: SetGame<CardContent>
    
    private static func createSetGame() -> SetGame<CardContent> {
        return SetGame() {symbol, shading, numberOfSymbols, color in
            // this is the closure
            // TODO: why is it such a dumbass way of doing i can't access shit
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


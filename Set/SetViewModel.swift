//
//  SetViewModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI



// TODO: deal 12 cards (at any point in time, there should always be 12 cards)
// keep finding sets until there are no more cards on the table

class SetViewModel: ObservableObject {
    
    @Published private var model: SetGame<CardProperties>
    
    private static func createSetGame() -> SetGame<CardProperties> {
        return SetGame() {symbol, shading, numberOfSymbols, color in
            return CardProperties(symbol: symbol, shading: shading, numberOfSymbols: numberOfSymbols, color: color)
        }
    }
    
    init() {
        model = SetViewModel.createSetGame()
    }

    func deal() {
        model.deal()
    }

    func newGame() {
        print("Starting a new game")
        model = SetViewModel.createSetGame()
    }

    func choose(_ card: SetGame<CardProperties>.Card) {
        model.choose(card)
    }
    
    func getSetStatus() -> SetGame<CardProperties>.chosenCardsState {
        return model.curSetStatus
    }
    
    // TODO: rework this
    func isDeckEmpty() -> Bool {
        return model.numDealtCards == model.cards.count
    }

    var cards: Array<SetGame<CardProperties>.Card> {
        let numDealt = model.numDealtCards
        return Array(model.cards.prefix(numDealt)).filter { card in
            !card.isMatched
        }
    }
    

    
    
    
}


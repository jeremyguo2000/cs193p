//
//  SetViewModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI

class SetViewModel: ObservableObject {
    
    @Published private var model: SetGame
    
    private static func createSetGame() -> SetGame {
        return SetGame() 
    }
    
    init() {
        model = SetViewModel.createSetGame()
    }

    func deal() {
        model.manualDeal()
    }

    func newGame() {
        print("Starting a new game")
        model = SetViewModel.createSetGame()
    }

    func choose(_ card: SetGame.Card) {
        model.choose(card)
    }
    
    func getSetStatus() -> SetGame.chosenCardsState {
        return model.curSetStatus
    }
    
    func isDeckEmpty() -> Bool {
        return model.numDealtCards == model.cards.count
    }

    var cards: Array<SetGame.Card> {
        let numDealt = model.numDealtCards
        return Array(model.cards.prefix(numDealt)).filter { card in
            !card.isMatched
        }
    }
    
    func getSelectionOverlay() -> SwiftUI.Color {
        switch(getSetStatus()) {
            case .too_few:
                return Color.gray
            case .invalid:
                return Color.red
            case .valid:
                return Color.green
        }
    }
    
    func getColor(_ card: SetGame.Card) -> SwiftUI.Color {
        switch (card.elemColor) {
        case .blue:
            SwiftUI.Color.blue
        case .yellow:
            SwiftUI.Color.yellow
        case .purple:
            SwiftUI.Color.purple
        }
    }
    
    func getShading(_ card: SetGame.Card) -> Double {
        switch (card.shading) {
        case .empty:
            0
        case .stripe:
            0.5
        case .fill:
            1
        }
    }
}


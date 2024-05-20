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

    // TODO: you should modifiy this function to return an array of CardViewData
    var cards: Array<SetGame.Card> {
        let numDealt = model.numDealtCards
        return Array(model.cards.prefix(numDealt)).filter { card in
            !card.isMatched
        }
    }
    
    // chatgpt suggests doing this to decouple the view from the model
    struct CardViewData : Identifiable {
        let id: String
        let shape: AnyShape
        let color: Color
        let fillOpacity: Double
        let numSymbols: Int
        let isSelected: Bool
    }
    
    // TODO: this is for decoupling, but is it really necessary?
    func getCardViewData(_ card: SetGame.Card) -> CardViewData {
        let shape = getShape(card)
        let color = getColor(card)
        let fillOpacity = getShading(card)
        let numSymbols = getNumSymbols(card)
        let isSelected = card.isSelected
        
        return CardViewData(id: card.id, shape: shape, color: color, fillOpacity: fillOpacity, numSymbols: numSymbols, isSelected: isSelected)
    }
    
    func getOverlayColorForSetStatus() -> SwiftUI.Color {
        switch(getSetStatus()) {
            case .too_few:
                return Color.gray
            case .invalid:
                return Color.red
            case .valid:
                return Color.green
        }
    }
    
    func getShape(_ card: SetGame.Card) -> AnyShape {
        switch(card.symbol) {
        case .diamond:
            AnyShape(Diamond())
        case .oval:
            AnyShape(Ellipse())
        case .rectangle:
            AnyShape(Rectangle())
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
    
    func getNumSymbols(_ card: SetGame.Card) -> Int {
        switch (card.numSymbols) {
            case .ONE:
                return 1
            case .TWO:
                return 2
            case .THREE:
                return 3
        }
    }
}


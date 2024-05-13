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
    private(set) var numChosenCards: Int
    
    let numStartCards = 12
    let setSize = 3 // num cards in a set
    
    
    // TODO: what should be the behavior when cards are matched? should we
    // put them somewhere else?
    
    init(cardContentFactory: (Symbol, Shading, NumberOfSymbols, ElemColor) -> CardContent) {
        cards = []
        numDealtCards = numStartCards
        numChosenCards = 0
        
        for symbol in Symbol.allCases {
            for shading in Shading.allCases {
                for numberOfSymbols in NumberOfSymbols.allCases {
                    for color in ElemColor.allCases {
                        let content = cardContentFactory(symbol, shading, numberOfSymbols, color)
                        let id =  "\(symbol.rawValue.prefix(2))_\(shading.rawValue.prefix(3))_\(numberOfSymbols.rawValue.prefix(3))_\(color.rawValue.prefix(2))"
                        let card = Card(content: content, id: id, symbol: symbol,
                                        shading: shading, numSymbols: numberOfSymbols, elemColor: color)
                        cards.append(card)
                    }
                }
            }
        }
        
        
        cards.shuffle()
        
        print(cards)
        print(cards.count)
        
    }
    
    // different selection states
    // blue -> selected, green -> 3 things form a set, red -> 3 things do not form a set
    // TODO: you need to keep track of how many cards are selected in total
 
    
    // func for selecting cards
    mutating func choose(_ card: Card) {
        print("chose \(card)")

        // TODO: you should only be able to choose up to 3, so you need to keep track
        
        // TODO: i think this is fine for now since the card order might change after match
        // In Swift, structures, enumerations, and tuples are all value types.
        let chosenIndex = cards.firstIndex(where: {$0.id == card.id})
        
        if cards[chosenIndex!].isSelected {
            cards[chosenIndex!].isSelected = false
            numChosenCards -= 1
            
        } else {
            cards[chosenIndex!].isSelected = true
            if numChosenCards < setSize { // 0, 1 cards selected
                numChosenCards += 1
                
                // TODO: if u have selected 3, the highlights of the card should change
                // TODO: should be a computed property
                // var isValidSet = isSet()
                
            } else {
                // TODO: this determines if the card is removed (if it's valid)
                deselectAllCards()
            }
            
        }
        
    }
    
    enum chosenCardsState: String {
        case too_few
        case invalid
        case valid
    }
    
    // checks if the current set of cards is a set
    // this will also determine the shading?
    func isSet() -> chosenCardsState {
        print("checking for set")
        
        // TODO: there are 3 states of the game
        //     1. < 3 cards selected, 2. a valid set is formed 3. an invalid set is formed
        
        if numChosenCards < setSize {
            return chosenCardsState.too_few
        }
        
        // check that for each feature, either all are same or all are different
        // symbol shading, number, color
        
        // track the indices of the cards that were chosen
        var chosenCardIdxs = [Int]()
        for idx in cards.indices {
            if cards[idx].isSelected {
                chosenCardIdxs.append(idx)
            }
        }
        
        // TODO: helper functions
        // all same
        // all different
        
        return chosenCardsState.valid
        
    }
    
    // TODO: make this a generic
    // T could be e.g. color
    func allSame<T: CaseIterable>(_ cardIdxs : [Int], _ curEnum : T) -> Bool {
        
        // for c in T.allCases {}
        // let card_1 = cards[cardIdxs[0]].
        // let card_1 = cards[cardIdxs[0]]
        
        return true
    }
    
    mutating func deselectAllCards() {
        print("deselect all cards")
        // TODO: reset all cards
        for i in cards.indices {
            cards[i].isSelected = false
        }
        numChosenCards = 0
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
    // you manipulate cards here, but you don't need to care about the view?
    // TODO: where should the data be?
    //  maybe it should be called a1, a2, a3, a4 for attributes?
    struct Card: Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id)"
        }
        
        var isSelected = false
        let content: CardContent
        let id: String
        let symbol: Symbol
        let shading: Shading
        let numSymbols: NumberOfSymbols
        let elemColor: ElemColor
    }
    

    
}

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

// TODO: figure out where to put the shit where

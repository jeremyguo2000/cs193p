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
    private(set) var curSetStatus: chosenCardsState
    private(set) var chosenCardIdxs: [Int]
    
    let numStartCards = 12
    let setSize = 3 // num cards in a set
    
    
    // TODO: what should be the behavior when cards are matched? should we
    // put them somewhere else?
    
    init(cardContentFactory: (Symbol, Shading, NumberOfSymbols, ElemColor) -> CardContent) {
        cards = []
        chosenCardIdxs = []
        numDealtCards = numStartCards
        curSetStatus = .too_few
        
        for symbol in Symbol.allCases {
            for shading in Shading.allCases {
                for numberOfSymbols in NumberOfSymbols.allCases {
                    for color in ElemColor.allCases {
                        let content = cardContentFactory(symbol, shading, numberOfSymbols, color)
                        let id =  "\(symbol.rawValue.prefix(4))_\(shading.rawValue.prefix(4))_\(numberOfSymbols.rawValue.prefix(4))_\(color.rawValue.prefix(4))"
                        let card = Card(content: content, id: id, symbol: symbol,
                                        shading: shading, numSymbols: numberOfSymbols, elemColor: color)
                        cards.append(card)
                    }
                }
            }
        }
        
        cards.shuffle()
        
    }
    
    mutating func choose(_ card: Card) {
        print("chose \(card)")
        
        // In Swift, structures, enumerations, and tuples are all value types.
        let chosenIndex = cards.firstIndex(where: {$0.id == card.id})
        print("In choose, chosenIndex \(String(describing: chosenIndex))")
        
        let cardOriginallySelected = cards[chosenIndex!].isSelected
        
        // already 3 selected cards, need to start again
        if chosenCardIdxs.count == setSize {
            deselectAllCards()
        }
        
        // 2nd condition is for when starting a new game (it's the 4th card selected from the previous round), you should still select the card
        if cardOriginallySelected && chosenCardIdxs.count != 0 {
            cards[chosenIndex!].isSelected = false
            chosenCardIdxs.removeAll { idx in
                print("removing idx is \(idx)")
                return cards[chosenIndex!].id == cards[idx].id
            }
            print("all chosen indices \(chosenCardIdxs)")

        } else {
            cards[chosenIndex!].isSelected = true
            chosenCardIdxs.append(chosenIndex!)
            print("all chosen indices \(chosenCardIdxs)")
        }
        
        isSet()
    }
    
    enum chosenCardsState: String {
        case too_few
        case invalid
        case valid
    }
    
    // checks if the current set of cards is a set
    mutating func isSet() -> Void {
        print("checking for set")
    
        if chosenCardIdxs.count < setSize {
            curSetStatus = chosenCardsState.too_few
            return
    
        }
    
        let symbolCheck = allSameOrDifferent(chosenCardIdxs) { idx in
            cards[idx].symbol
        }
        print("symbolCheck was \(symbolCheck)")
        
        let shadingCheck = allSameOrDifferent(chosenCardIdxs) { idx in
            cards[idx].shading
        }
        print("shadingCheck was \(shadingCheck)")
        
        
        let numCheck = allSameOrDifferent(chosenCardIdxs) { idx in
            cards[idx].numSymbols
        }
        print("numCheck was \(numCheck)")
        
        let colorCheck = allSameOrDifferent(chosenCardIdxs) { idx in
            cards[idx].elemColor
        }
        print("colorCheck was \(colorCheck)")
        
        curSetStatus = (symbolCheck && shadingCheck && numCheck && colorCheck) ? chosenCardsState.valid : chosenCardsState.invalid
        
        print("chosenIdxs \(chosenCardIdxs)")
        print("curSetStatus is \(curSetStatus)")
    }
    
    // the property closure takes the index of the card (in cards) and looks up the desired field
    // we use generic since maybe the card properties could be Int or String
    // written by chatgpt
    func allSameOrDifferent<U: Equatable & Hashable>(_ chosenCardIdxs : [Int], property: (Int) -> U) -> Bool {
        
        // IMPT: you need to access this here since allSame and allDiff access the elem directly
        let firstVal = property(chosenCardIdxs[0])
        
        let allSame = chosenCardIdxs.allSatisfy { idx in
            print("Comparing \(property(idx)) at idx \(idx) with \(firstVal)")
            return property(idx) == firstVal
        }
        
        let allDiff = Set(chosenCardIdxs.map { idx in
            print("Property value at index \(idx): \(property(idx))")
            return property(idx)
        }).count == chosenCardIdxs.count
        
        print("allSame \(allSame)")
        print("allDiff \(allDiff)")
        
        return allSame || allDiff
    }
    

    
    mutating func deselectAllCards() {
        print("deselect all cards")
        for i in cards.indices {
            cards[i].isSelected = false
        }
        chosenCardIdxs = [] // TODO: check if anything else
        curSetStatus = .too_few
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
    
    struct Card: Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id)"
        }
        
        var isSelected = false
        // maybe this could be a picture or some shit that doesn't affect the gameplay and it's less impt to access it?
        let content: CardContent
        let id: String
        let symbol: Symbol
        let shading: Shading
        let numSymbols: NumberOfSymbols
        let elemColor: ElemColor
    }
    

    
}

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

struct CardProperties {
    let symbol: Symbol
    let shading: Shading
    let numberOfSymbols: NumberOfSymbols
    let color: ElemColor
}

// TODO: figure out where to put the shit where (Model or ViewModel?)

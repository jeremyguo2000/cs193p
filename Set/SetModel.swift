//
//  SetModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import Foundation

// TODO: get rid of CardContent, seems redundant

struct SetGame<CardContent> {
    
    private(set) var cards: Array<Card>
    private(set) var numDealtCards: Int
    private(set) var curSetStatus: chosenCardsState
    private(set) var chosenCardIdxs: [Int]
    
    private let numStartCards = 12
    private let setSize = 3 // num cards in a set
    
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
    
    // removed the selected cards if they are a match, then deal
    // returns true if the currently selected card was part of the matched set
    // the result is useful when you select the 4th card, but
    // not used when you press Deal (since the chosenCard will be one of the 3 selected)
    // chosenIndex is the index into the cards array of the card that's chosen
    mutating func removeMatchAndDeal(_ chosenIndex: Int?) -> Bool {
        var cardIsFromMatchedSet = false
        // already 3 selected cards, need to start again
        if chosenCardIdxs.count == setSize {
            // check if it's a valid set, then remove it from the deck and deal 3 cards
            if curSetStatus == chosenCardsState.valid {
                chosenCardIdxs.forEach {
                    cards[$0].isMatched = true
                    cardIsFromMatchedSet = chosenCardIdxs.contains(chosenIndex!)
                }
                dealThreeCards()
            }
            deselectAllCards()
        }
        return cardIsFromMatchedSet
    }
    
    // helper function for deal
    mutating func dealThreeCards() {
        numDealtCards += 3
    }
    
    // func for dealing
    // TODO: this is too similar to removeMatchAndDeal?
    mutating func deal() {
        // if the current 3 selected cards form a match, remove them
        if chosenCardIdxs.count == setSize {
            // check if it's a valid set, then remove it from the deck and deal 3 cards
            if curSetStatus == chosenCardsState.valid {
                chosenCardIdxs.forEach {
                    cards[$0].isMatched = true
                }
                deselectAllCards()
            }
        }
        
        // always deal 3 more cards
        dealThreeCards()
    }
    
    mutating func choose(_ card: Card) {
        print("chose \(card)")
        
        // In Swift, structures, enumerations, and tuples are all value types.
        let chosenIndex = cards.firstIndex(where: {$0.id == card.id})
        print("In choose, chosenIndex \(String(describing: chosenIndex))")
        
        // rmb this since deselection resets all the states
        let cardWasPreviouslySelected = cards[chosenIndex!].isSelected
        var cardIsFromMatchedSet = false
        
        cardIsFromMatchedSet = removeMatchAndDeal(chosenIndex)
        
        // 2nd condition is for when starting a new game (it's the 4th card selected from the previous round),
        // you should still select the card UNLESS it was part of the matched set
        if cardWasPreviouslySelected && (chosenCardIdxs.count != 0 || cardIsFromMatchedSet) {
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
        
        // you want to display the borders after 3 cards are clicked
        // but the actual removal and resetting etc. is done only on the 4th click
        checkForSet()
    }
    
    enum chosenCardsState: String {
        case too_few
        case invalid
        case valid
    }
    
    // checks if the current set of cards is a set
    // also marks the cards as matched if so
    mutating func checkForSet() -> Void {
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
        var isMatched = false
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


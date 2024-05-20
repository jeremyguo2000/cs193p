//
//  SetModel.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import Foundation

struct SetGame {
    
    private(set) var cards: Array<Card>
    private(set) var numDealtCards: Int
    private(set) var curSetStatus: chosenCardsState
    private(set) var chosenCardIdxs: [Int]
    
    private let numStartCards = 12
    private let setSize = 3 // num cards in a set
    
    init() {
        cards = []
        chosenCardIdxs = []
        numDealtCards = numStartCards
        curSetStatus = .too_few
        
        for symbol in Symbol.allCases {
            for shading in Shading.allCases {
                for numberOfSymbols in NumberOfSymbols.allCases {
                    for color in ElemColor.allCases {
                        let id =  "\(symbol.rawValue.prefix(4))_\(shading.rawValue.prefix(4))_\(numberOfSymbols.rawValue.prefix(4))_\(color.rawValue.prefix(4))"
                        let card = Card(id: id, symbol: symbol,
                                        shading: shading, numSymbols: numberOfSymbols, elemColor: color)
                        cards.append(card)
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    // Refactored with chatGPT but i had to edit some parts
    // the actual set checking logic is in checkForSet
    // this code is responsible for marking the cards as matched
    // chosenIndex might be the idx of the 4th clicked card
    // or null if from pressing the deal button
    private mutating func checkMatch(_ chosenIndex:Int?) -> Bool {
        var cardIsFromMatchedSet = false
        if curSetStatus == chosenCardsState.valid {
            chosenCardIdxs.forEach {
                cards[$0].isMatched = true
            }
            if let chosenIndex = chosenIndex {
                cardIsFromMatchedSet = chosenCardIdxs.contains(chosenIndex)
            }
            dealThreeCards()
            deselectAllCards()
        }
        return cardIsFromMatchedSet
    }
    
    // this path is from clicking the fourth card
    // note we deal if there's a match (to replace),
    // but just deselect it's not (and has 3 cards)
    private mutating func checkMatchAndDeal(_ chosenIndex: Int?) -> Bool {
        var cardIsFromMatchedSet = false
        if chosenCardIdxs.count == setSize {
            cardIsFromMatchedSet = checkMatch(chosenIndex)
            deselectAllCards()
        }
        return cardIsFromMatchedSet
    }
    
    // this path is from the actual button
    // note this way we always deal 3 cards, valid or invalid
    mutating func manualDeal() {
        if curSetStatus == chosenCardsState.valid {
            _ = checkMatch(nil)
        } else {
            dealThreeCards()
        }
    }
    
    // helper function for deal
    private mutating func dealThreeCards() {
        numDealtCards = min(numDealtCards + 3, cards.count)
    }

    mutating func choose(_ card: Card) {
        print("chose \(card)")
        
        // In Swift, structures, enumerations, and tuples are all value types.
        let chosenIndex = cards.firstIndex(where: {$0.id == card.id})
        print("In choose, chosenIndex \(String(describing: chosenIndex))")
        
        // rmb this since deselection resets all the states
        let cardWasPreviouslySelected = cards[chosenIndex!].isSelected
        var cardIsFromMatchedSet = false
        
        cardIsFromMatchedSet = checkMatchAndDeal(chosenIndex)
        
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
    private func allSameOrDifferent<U: Equatable & Hashable>(_ chosenCardIdxs : [Int], property: (Int) -> U) -> Bool {
        
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
    
    private mutating func deselectAllCards() {
        print("deselect all cards")
        for i in cards.indices {
            cards[i].isSelected = false
        }
        chosenCardIdxs = []
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
        // content: not present but maybe this could be a picture or something and it's less impt to access
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


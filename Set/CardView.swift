//
//  CardView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/9/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame<CardContent>.Card
    
    init(_ card: SetGame<CardContent>.Card) {
        self.card = card
    }
    
    // TODO: factor out your magic constants and shit
    // TODO: adaptive sizing
    
    var body: some View {
        ZStack (alignment: .center) {
            let base = RoundedRectangle(cornerRadius: 12) // TODO: adaptive sizing
            Group {
                base.fill(.white).strokeBorder(lineWidth: 2)
                VStack {
                    Text(card.id)
                    applyCount(to: Diamond(), count: 3)
                }
            }
        }.overlay(card.isSelected ? .blue.opacity(0.3) : .blue.opacity(0))
    }
    }

func applyCount(to shape: some Shape, count: Int) -> some View {
    return
        ForEach(0..<count, id: \.self, content: { _ in
            shape
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width:W, height: H)
        }).padding(5)
}

// TODO: create some enum for the card builder
// TODO: rename, is this the right func signature?
// symbol, shading, numSymbols, color
// diamond, rectangle, oval
// build a cardview for the card
func cardViewBuilder(_ card: SetGame<CardContent>.Card) {
    
    
    
}

struct CardView_Previews:  PreviewProvider {
    static var previews: some View {
        // TODO: put multiple cards
        CardView(SetGame<CardContent>.Card(content: CardContent(symbol: .diamond, shading: .empty, numberOfSymbols: .ONE, color: .blue), id: "test"))
            
    }
    
}

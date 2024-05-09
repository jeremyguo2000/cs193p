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
    // TODO: adaptive sizing of cards
    // TODO: card sizes must be UNIFORM
    
    var body: some View {
        ZStack (alignment: .center) {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white).strokeBorder(lineWidth: 2)
                VStack {
                    // TODO Text(card.id)
                    applyCount(to: Diamond(), count: card.content.numberOfSymbols.getNumSymbols())
                    
                    // TODO: fix this shit
                    applyColor(to: applyColor(to: Circle()))
                    
                }
            }
        }.overlay(card.isSelected ? .blue.opacity(0.3) : .blue.opacity(0))
    }
    }

// TODO: this doesn't seem to work well with other functions
// ZZZZZ
func applyColor(to shape: some Shape) -> some Shape {
    shape.stroke(.red, lineWidth: 2)
    return shape
}


func applyShading(to shape: some Shape, shading: Shading) -> some View {
    
    switch shading {
        case .empty: return shape.opacity(0)
        case .stripe: return shape.opacity(0.5)
        case .fill: return shape.opacity(0)
    }
    
}

func applyCount(to shape: some Shape, count: Int) -> some View {
    return
        ForEach(0..<count, id: \.self, content: { _ in
            shape
                .frame(width:W, height: H)
        }).padding(5)
}

// TODO: create some enum for the card builder
// TODO: rename, is this the right func signature?
// symbol, shading, numSymbols, color
// diamond, rectangle, oval
// build a cardview for the card

extension Shape {
    
    // TODO: this doesn't seem to work well after chaining
    
    func repeated(_ times: Int) -> some View {
        return ForEach(0..<times, id: \.self, content: { _ in
            self.frame(width:W, height: H)
        })
    }
    
    
}


struct CardView_Previews:  PreviewProvider {
    static var previews: some View {
    
        // TODO: put multiple cards
        HStack {
            CardView(SetGame<CardContent>.Card(content: CardContent(symbol: .diamond, shading: .empty, numberOfSymbols: .ONE, color: .blue), id: "test"))
            
            CardView(SetGame<CardContent>.Card(content: CardContent(symbol: .diamond, shading: .stripe, numberOfSymbols: .ONE, color: .blue), id: "test"))
                
            
            CardView(SetGame<CardContent>.Card(content: CardContent(symbol: .diamond, shading: .fill, numberOfSymbols: .ONE, color: .blue), id: "test"))
            
        }
       
            
            
    }
    
}

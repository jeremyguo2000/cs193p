//
//  CardView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/9/24.
//

import SwiftUI

// TODO: revise what a ViewBuilder is

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
                    buildShape(card: card)
                }
            }
        }.overlay(card.isSelected ? .blue.opacity(0.3) : .blue.opacity(0))
    }
}

// builds a shape based on the card
// TODO: why do i need this goddamn AnyShape
// TODO: use generics??
func buildShape(card: SetGame<CardContent>.Card) -> some View {
        
    let finalView = switch(card.content.symbol) {
    case .diamond:
        AnyShape(Diamond())
            .applyColor(desiredColor: card.content.color)
            .duplicate(count: card.content.numberOfSymbols.getNumSymbols())
        //Diamond()
    case .oval:
        AnyShape(Ellipse())
            .applyColor(desiredColor: card.content.color)
            .duplicate(count: card.content.numberOfSymbols.getNumSymbols())
        //Ellipse()
    case .rectangle:
        AnyShape(Rectangle())
            .applyColor(desiredColor: card.content.color)
            .duplicate(count: card.content.numberOfSymbols.getNumSymbols())
    }
    
    // TODO: magic constant
    // TODO: if there's only one shape it should not expand
    return finalView.padding(8)
        
}
    



// TODO: use viewModifier? is this necessary?
struct Cardify: ViewModifier {
    
    // TODO: turn that shit into a card
    func body(content: Content) -> some View {
        
    }
    
}

struct DuplicateModifier: ViewModifier {
    let count: Int
    
    func body(content: Content) -> some View {
        ForEach(0..<count, id: \.self) {_ in
            content
        }
    }
}

extension View {
    func duplicate(count: Int) -> some View {
        modifier(DuplicateModifier(count: count))
    }
    
    func applyColor(desiredColor: ElemColor) -> some View {
        modifier(ColorModifier(desiredColor: desiredColor))
    }
    
    // TODO: shading chooser
}

// TODO: very messy with all these colors and shit
struct ColorModifier: ViewModifier {
    var desiredColor: ElemColor
    
    func body(content: Content) -> some View {
        
        let outputColor = switch (desiredColor) {
            case .blue:
                SwiftUI.Color.blue
            case .yellow:
                SwiftUI.Color.yellow
            case .purple:
                SwiftUI.Color.purple
        }
        
        return content.foregroundColor(outputColor)
        // content.border(color)
        
    }
}

// TODO: this doesn't seem to work well with other functions
func applyColor(to shape: some Shape) -> some View {
    ZStack {
        shape.fill(.red)
        shape.stroke(.red)
    }
}

func applyShading(to shape: some Shape, shading: Shading) -> some View {
    
    switch shading {
        case .empty: return shape.opacity(0)
        case .stripe: return shape.opacity(0.5)
        case .fill: return shape.opacity(0)
    }
    
}

// TODO: i think do this last since this is after the shape modification
func applyCount(to shape: some Shape, count: Int) -> some View {
    return
        ForEach(0..<count, id: \.self, content: { _ in
            shape
                .frame(width:W, height: H)
        }).padding(5)
}

// TODO: create some enum for the card builder
// TODO: rename, is this the right func signature?
// symbol,  numSymbols, color, shading, --> color, shading, symbol group together
// diamond, rectangle, oval
// build a cardview for the card

// flow is like this
// choose symbol --> color, shading --> multiply

// TODO: look at ViewModifier, i believe that's the correct approach

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

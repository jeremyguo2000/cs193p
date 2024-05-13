//
//  CardView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/9/24.
//

import SwiftUI

// TODO: factor out your magic constants and shit
// TODO: adaptive sizing of cards
// TODO: card sizes must be UNIFORM
// TODO: GeometryReader to figure out the card's aspect ratio
// TODO: should shapes expand to take up all available space?
//       or should they always take up the same space
// TODO: AspectVGrid??

struct CardView: View {
    let card: SetGame<CardContent>.Card
    
    init(_ card: SetGame<CardContent>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack (alignment: .center) {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white).strokeBorder(lineWidth: 2)
                VStack {
                    getViewFromCard(card)
                }
            }
        }.overlay(card.isSelected ? .blue.opacity(0.3) : .blue.opacity(0))
        // TODO: overlay has to change color when 3 are selected --> where is this info passed in?
        // --> GREEN for a match
        // --> RED for a mismatch
        // TODO: remove the cards
    }
    
    func getSelectionOverlay() -> SwiftUI.Color {
        return .blue.opacity(0.3)
    }
    
    
    // TODO: low priority why do i need this goddamn AnyShape
    // TODO: use generics??
    //https://stackoverflow.com/questions/62602166/how-to-use-same-set-of-modifiers-for-various-shapes/62605936#62605936
    @ViewBuilder
    func getViewFromCard(_ card: SetGame<CardContent>.Card) -> some View {
        let shape = switch(card.symbol) {
        case .diamond:
            AnyShape(Diamond())
            //Diamond()
        case .oval:
            AnyShape(Ellipse())
            //Ellipse()
        case .rectangle:
            AnyShape(Rectangle())
        }
        
        let shapeColor = getColor(card)
        let shapeOpacity = getShading(card)
        
        // don't need explicit return with @ViewBuilder
        shape
            .stroke(shapeColor, lineWidth: 3)
            .overlay(shape.fill(shapeColor.opacity(shapeOpacity)))
            .duplicate(count: card.numSymbols.getNumSymbols())
            .padding(8)
    }
    
    func getColor(_ card: SetGame<CardContent>.Card) -> SwiftUI.Color {
        switch (card.elemColor) {
        case .blue:
            SwiftUI.Color.blue
        case .yellow:
            SwiftUI.Color.yellow
        case .purple:
            SwiftUI.Color.purple
        }
    }
    
    // TODO: should this be in the viewModel?
    func getShading(_ card: SetGame<CardContent>.Card) -> Double {
        switch (card.shading) {
        case .empty:
            0
        case .stripe:
            0.3
        case .fill:
            1
        }
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
}

struct CardView_Previews:  PreviewProvider {
    static var previews: some View {
    
        HStack {
            //CardView(SetGame<CardContent>.Card(content: CardContent(symbol: .diamond, shading: .empty, numberOfSymbols: .ONE, color: .blue), id: "test", test:"f"))
            
            ZStack {
                AnyShape(Rectangle())
                    .stroke(Color.blue, lineWidth: 5)
                AnyShape(Rectangle())
                    .fill(Color.blue.opacity(0))
            }
            ZStack {
                AnyShape(Rectangle())
                    .stroke(Color.blue, lineWidth: 5)
                AnyShape(Rectangle())
                    .fill(Color.blue.opacity(0.5))
            }
            // alternative to ZStack
            AnyShape(Rectangle())
                .stroke(Color.blue, lineWidth: 5)
                .overlay(
                    AnyShape(Rectangle())
                        .fill(Color.blue.opacity(0.2))
                )
            ZStack {
                AnyShape(Rectangle())
                    .stroke(Color.blue, lineWidth: 5)
                AnyShape(Rectangle())
                    .fill(Color.blue.opacity(1))
            }



        }
    }
    
}

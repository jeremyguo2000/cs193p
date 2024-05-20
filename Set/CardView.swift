//
//  CardView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/9/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    @ObservedObject var viewModel: SetViewModel
    
    private struct Constants {
        static let cardCornerRadius = CGFloat(12)
        static let cardBorder = CGFloat(2)
        static let cardSelectedOpacity = 0.3
        static let cardUnselectedOpacity = 0.0
        static let shapeBorder = CGFloat(3)
        static let shapePadding = CGFloat(8)
    }
    
    var body: some View {
        ZStack (alignment: .center) {
            let base = RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
            Group {
                base.fill(.white).strokeBorder(lineWidth: Constants.cardBorder)
                VStack {
                    getViewFromCard(card)
                }
            }
        }.overlay(getSelectionOverlay().opacity(card.isSelected ? Constants.cardSelectedOpacity : Constants.cardUnselectedOpacity))
    }
    
    func getSelectionOverlay() -> SwiftUI.Color {
        
        switch(viewModel.getSetStatus()) {
        case .too_few:
            return Color.gray
        case .invalid:
            return Color.red
        case .valid:
            return Color.green
        }
            

    }
    
    //https://stackoverflow.com/questions/62602166/how-to-use-same-set-of-modifiers-for-various-shapes/62605936#62605936
    @ViewBuilder
    func getViewFromCard(_ card: SetGame.Card) -> some View {
        let shape = switch(card.symbol) {
        case .diamond:
            AnyShape(Diamond())
        case .oval:
            AnyShape(Ellipse())
        case .rectangle:
            AnyShape(Rectangle())
        }
        
        let shapeColor = getColor(card)
        let shapeOpacity = getShading(card)
        
        // don't need explicit return with @ViewBuilder
        shape
            .stroke(shapeColor, lineWidth: Constants.shapeBorder)
            .overlay(shape.fill(shapeColor.opacity(shapeOpacity)))
            .duplicate(count: card.numSymbols.getNumSymbols())
            .padding(Constants.shapePadding)
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

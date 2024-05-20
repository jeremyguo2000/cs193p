//
//  CardView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/9/24.
//

import SwiftUI

// TODO: i think some of this code belongs in the ViewModel

struct CardView: View {
    let card: SetViewModel.CardViewData
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
        }.overlay(viewModel.getOverlayColorForSetStatus().opacity(card.isSelected ? Constants.cardSelectedOpacity : Constants.cardUnselectedOpacity))
    }
    
    //https://stackoverflow.com/questions/62602166/how-to-use-same-set-of-modifiers-for-various-shapes/62605936#62605936
    @ViewBuilder
    // TODO: you should still not be passing SetGame.Card 
    func getViewFromCard(_ card: SetViewModel.CardViewData) -> some View {
        let shape = card.shape
        let shapeColor = card.color
        let shapeOpacity = card.fillOpacity
        let numSymbols = card.numSymbols
        
        // don't need explicit return with @ViewBuilder
        shape
            .stroke(shapeColor, lineWidth: Constants.shapeBorder)
            .overlay(shape.fill(shapeColor.opacity(shapeOpacity)))
            .duplicate(count: numSymbols)
            .padding(Constants.shapePadding)
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

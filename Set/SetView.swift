//
//  SetView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI

struct SetView: View {
    
    // Observed objects are always passed into you. This view is passed into you
    @ObservedObject var viewModel: SetViewModel
    
    private struct Constants {
        static let cardScrollLimit = 20
        static let minCardWidth = CGFloat(65)
        static let aspectRatio = CGFloat(2.0/3.0)
        static let cardPadding = CGFloat(6)
        static let cardSpacing = CGFloat(0)
    }
    
    var body: some View {
        VStack {
            cards
            (viewModel.isDeckEmpty() ? nil :
            Button("Deal") {
                viewModel.deal()
            })
            Button("New Game") {
                viewModel.newGame()
            }
        }
        .padding()
    }
    
    
    var cards: some View {
        GeometryReader { geometry in
            let tooManyCards = viewModel.cards.count > Constants.cardScrollLimit
            var gridItemSize : CGFloat
            
            if tooManyCards {
                gridItemSize = Constants.minCardWidth
            } else { gridItemSize = gridItemWidthThatFits(
                count: viewModel.cards.count,
                size: geometry.size,
                atAspectRatio: Constants.aspectRatio)
            }
    
            let grid = LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: Constants.cardSpacing)],
                                 spacing: Constants.cardSpacing) {
                ForEach(viewModel.cards) { card in
                    CardView(cardViewData: card, viewModel: viewModel)
                        .aspectRatio(Constants.aspectRatio, contentMode: .fit)
                        .padding(Constants.cardPadding)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
            
            return Group {
                tooManyCards ? AnyView(ScrollView {grid}) : AnyView(grid)
            }
            
        }
    }
    
    func gridItemWidthThatFits (count: Int, size: CGSize,
        atAspectRatio aspectRatio: CGFloat) -> CGFloat {
        
        let count = CGFloat(count)
        var columnCount = 1.0
        
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        
        return min(size.width / count, size.height*aspectRatio).rounded(.down)
    }
    
    
}

#Preview {
    SetView(viewModel: SetViewModel())
}

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
    
    var body: some View {
        VStack {
            // TODO: the ScrollView messes up the adaptive shit
            // TODO: switch to ScrollView when more than 5 columns
            //ScrollView {
                cards
            //}
            Spacer()
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
            
            // TODO: magic constants galore
            let tooManyCards = viewModel.cards.count > 30
            var gridItemSize : CGFloat
            
            if tooManyCards {
                gridItemSize = 65
            } else { gridItemSize = gridItemWidthThatFits(
                count: viewModel.cards.count,
                size: geometry.size,
                atAspectRatio: 2/3)
            }
    
            
            let grid = LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card, viewModel: viewModel)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(6)
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

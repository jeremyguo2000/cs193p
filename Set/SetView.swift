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
            ScrollView {
                cards
            }
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card: card, viewModel: viewModel)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(8)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
    }
}

#Preview {
    SetView(viewModel: SetViewModel())
}

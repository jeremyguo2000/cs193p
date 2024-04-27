//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/23/24.
//

import SwiftUI

// This is the view

enum Theme: String {
    case furniture
    case animals
    case sports
}

struct EmojiMemoryGameView: View {
    // Observed objects are always passed into you. This view is passed into you
    // no equals, no assignment etc.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            title
            ScrollView {
                cards
            }
            Spacer()
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        .padding()
        
    }
    
    struct VerticalLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration.icon
                configuration.title
            }
        }
    }
    
    var title: some View {
        Text("Memorize!").font(.largeTitle)
    }
    
    var cards: some View {
        LazyVGrid(columns:[GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack (alignment: .center, content: {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        })
    }
    
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        // ok to create on the fly, since preview constantly redrawn
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

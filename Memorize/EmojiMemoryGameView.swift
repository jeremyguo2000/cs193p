//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/23/24.
//

import SwiftUI

// This is the view
struct EmojiMemoryGameView: View {
    // Observed objects are always passed into you. This view is passed into you
    // no equals, no assignment etc.
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            title
            Spacer()
            curTheme
            Spacer()
            ScrollView {
                cards.animation(.default, value: viewModel.cards)
            }
            Spacer()
            score
            Spacer()
    
            Button("New Game") {
                viewModel.newGame()
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
    
    var score: some View {
        Text("score: \(viewModel.score)")
    }
    
    var curTheme: some View {
        Text("\(viewModel.getTheme)")
            .font(.title3)
            .padding(15)
            .border(viewModel.getThemeCardColor(), width: 1)
    }

    var title: some View {
        Text("Memorize!").font(.largeTitle)
    }
    
    var cards: some View {
        LazyVGrid(columns:[GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(viewModel.getThemeCardColor())
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
        // removes matched cards from the screen 
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        
        
    }
    
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        // ok to create on the fly, since preview constantly redrawn
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

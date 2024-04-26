//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/23/24.
//

import SwiftUI

enum Theme: String {
    case furniture
    case animals
    case sports
}

let furnitureCards = [Card("🪑"),Card("🛋️"),Card("🛌"),Card("📺"),Card("🪑"),Card("🛋️"),Card("🛌"),Card("📺")]
let animalCards = [Card("🐶"),Card("🐭"),Card("🐞"),Card("🪿"),Card("🐢"),Card("🐶"),Card("🐭"),Card("🐞"),Card("🪿"),Card("🐢")]
let sportsCards = [Card("⚽️"),Card("🏀"),Card("🏈"),Card("⚾️"),Card("🏓"),Card("🎳"),Card("⚽️"),Card("🏀"),Card("🏈"),Card("⚾️"),Card("🏓"),Card("🎳")]

struct EmojiMemoryGameView: View {
    // Observed objects are always passed into you. This view is passed into you
    @ObservedObject var viewModel: EmojiMemoryGame
    
    
    @State var themes = [Theme.furniture: furnitureCards,
                  Theme.animals: animalCards,
                  Theme.sports: sportsCards]
    @State var theme: Theme = Theme.furniture
    @State var themeCards: Array<Card> = furnitureCards
    @State var cardCount: Int = 0
    
    var body: some View {
        VStack {
            title
            helpfulInstructions
            ScrollView {
                cards
            }
            Spacer()
            themeSelectors
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
    
    func themeSetter(symbol: String, caption: String, selectedTheme: Theme) -> some View {
            
        return Button(caption, systemImage: symbol, action: {
            theme = selectedTheme
            themeCards = themes[theme]!
            themeCards.shuffle()
            cardCount = themes[theme]!.count
        })
            .font(.caption).labelStyle(VerticalLabelStyle())
    }
    
    var furnitureThemeSetter: some View {
        themeSetter(symbol: "sofa", caption: "furniture", selectedTheme:Theme.furniture)
    }
    
    var animalThemeSetter: some View {
        themeSetter(symbol: "tortoise", caption: "animals", selectedTheme:Theme.animals)
    }
    
    var sportsThemeSetter: some View {
        themeSetter(symbol: "baseball", caption: "sports", selectedTheme:Theme.sports)
    }
    
    var title: some View {
        Text("Memorize!").font(.largeTitle)
    }
    
    func styleHelpfulInstructions(_ text: Text) -> some View {
        text.font(.title3).multilineTextAlignment(.center)
    }
    
    var helpfulInstructions: some View {
        var instructions = Text("")
        if cardCount == 0 {
            instructions = Text("Press any of the buttons below to begin!")
            return  AnyView(VStack {
                Spacer()
                styleHelpfulInstructions(instructions)
            })
        } else {
            return AnyView(styleHelpfulInstructions(instructions))
        }
        
    }
    
    var cards: some View {
        LazyVGrid(columns:[GridItem(.adaptive(minimum: 100))]) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                CardView(card: viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
    var themeSelectors: some View {
        HStack {
            furnitureThemeSetter
            Spacer()
            animalThemeSetter
            Spacer()
            sportsThemeSetter
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
}

// each card should be an object with (emoji, flipped state)
struct Card {
    let emoji: String
    
    init(_ emoji: String) {
        self.emoji = emoji
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    var body: some View {
        ZStack (alignment: .center, content: {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content).font(.largeTitle)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        })
    }
    
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

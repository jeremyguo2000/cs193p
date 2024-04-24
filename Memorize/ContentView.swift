//
//  ContentView.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/23/24.
//

import SwiftUI

struct ContentView: View {
    
    enum Theme: String {
        case furniture
        case animals
        case sports
    }
    
    @State var themes = [Theme.furniture: ["🪑","🛋️","🛌","📺","🪑","🛋️","🛌","📺"],
                  Theme.animals: ["🐶","🐭","🐞","🪿","🐢","🐶","🐭","🐞","🪿","🐢"],
                  Theme.sports: ["⚽️","🏀","🏈","⚾️","🏓","🎳","⚽️","🏀","🏈","⚾️","🏓","🎳"]]
    
    @State var theme: Theme = Theme.furniture
    
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
    
    func resetCardsFaceDown() {
        print("resetting!!!")
        // TODO: when you change theme, all the cards must go back to original flipped state!
    }
    
    func themeSetter(symbol: String, caption: String, selectedTheme: Theme) -> some View {
            
        return Button(caption, systemImage: symbol, action: {
            theme = selectedTheme
            themes[theme]?.shuffle()
            resetCardsFaceDown()
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
            ForEach(0..<cardCount, id: \.self) {index in
                CardView(content:themes[theme]![index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }.foregroundColor(.orange)
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

struct CardView: View {
    let content: String
    @State var isFaceUp = false
    
    var body: some View {
        ZStack (alignment: .center, content: {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }).onTapGesture(count: 1, perform: {
            isFaceUp.toggle()
        })
    }
}

#Preview {
    ContentView()
}

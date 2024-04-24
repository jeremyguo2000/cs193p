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
    
    var themes = [Theme.furniture: ["🪑","🛋️","🛌","📺","🪑","🛋️","🛌","📺"],
                  Theme.animals: ["🐶","🐭","🐞","🪿","🐢","🐶","🐭","🐞","🪿","🐢"],
                  Theme.sports: ["⚽️","🏀","🏈","⚾️","🏓","🎳","⚽️","🏀","🏈","⚾️","🏓","🎳"]]
    
    // TODO: use enums for the theme
    @State var theme: Theme = Theme.furniture
    
    // TODO: deprecate this cardCount, call it pairCount
    // TODO: create a function to update this when the theme changes
    @State var cardCount: Int = 0
        
    var body: some View {
        VStack {
            title
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
        
        // TODO needs to update the theme by calling the appropriate theme setters
        // TODO what should the return type be?
        // TODO: this should have some side effects
        
        //Button(<#PrimitiveButtonStyleConfiguration#>)
        print("inside themeSetter")
        
        return Button(caption, systemImage: symbol, action: {
            print("pressed ")
            
            let printCaption = " the caption for this button is \(caption)"
            print(printCaption)
            
            // TODO: why is this shit called 3 times??
            let printTheme = " the theme selected by this button is \(theme)"
            print(printTheme)
            theme = selectedTheme
    
            
            // TODO: shuffle?
            // themes[theme]?.shuffle()
            
            cardCount = themes[theme]!.count
            let printCardCount = " the cardcount for this theme is \(cardCount)"
            print(printCardCount)
            
        })
            .font(.caption).labelStyle(VerticalLabelStyle())
            //Image(systemName: symbol)
            //Text(caption).font(.caption2)

    }
    
    // TODO: i don't think u need 3 of these
    var furnitureThemeSetter: some View {
        // TODO:
        themeSetter(symbol: "sofa", caption: "furniture", selectedTheme:Theme.furniture)
    }
    
    var animalThemeSetter: some View {
        // TODO combine these 2 into 1
        themeSetter(symbol: "tortoise", caption: "animals", selectedTheme:Theme.animals)
    }
    
    var sportsThemeSetter: some View {
        themeSetter(symbol: "baseball", caption: "sports", selectedTheme:Theme.sports)
    }
    
    
    var title: some View {
        Text("Memorize!").font(.largeTitle)
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
    
/*
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            if cardCount > 1 {
                cardCount += offset
            }
            
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount+offset < 1 || cardCount+offset>themes[theme]!.count)
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: 1, symbol: "rectangle.stack.badge.plus.fill")
    } 
    */
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

//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Xiuzhen Guo on 4/23/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: <#T##EmojiMemoryGame#>)
        }
    }
}

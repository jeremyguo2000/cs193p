//
//  SetApp.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var game = SetViewModel()
    
    var body: some Scene {
        WindowGroup {
            SetView(viewModel: game)
        }
    }
}

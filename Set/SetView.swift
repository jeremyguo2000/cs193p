//
//  SetView.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/6/24.
//

import SwiftUI

struct SetView: View {
    
    // Observed objects are always passed into you. This view is passed into you
    // no equals, no assignment etc.
    @ObservedObject var viewModel: SetViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Spacer()
            Button("Deal") {
                viewModel.deal()
            }
            Spacer()
            Button("New Game") {
                viewModel.newGame()
            }
           
            
        }
        .padding()
    }
}

#Preview {
    SetView(viewModel: SetViewModel())
}

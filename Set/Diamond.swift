//
//  Diamond.swift
//  Set
//
//  Created by Xiuzhen Guo on 5/9/24.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        return p
    }
    
}

// TODO: tidy this
let W = CGFloat(90)
let H = CGFloat(45)

// TODO: use a Grid

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            HStack() {
                VStack() {
                    Diamond()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .frame(width:W, height: H)
                    Diamond()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .frame(width:W, height: H)
                }
                Spacer()
                Ellipse()
                    .foregroundColor(.teal)
                    .frame(width:W, height: H)
                Spacer()
                Rectangle()
                    .foregroundColor(.orange)
                    .frame(width:W, height: H)
                
            }.padding(10)
            
            // use this to programmatically create your card
            VStack {
                ForEach(0..<3, content: { _ in
                    Rectangle()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .frame(width:W, height: H)
                })
            }
            
        }
       
    }
}



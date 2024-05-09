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
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return p
    }
    
}

// TODO: tidy this shit, don't hardcode, make adaptive
let W = CGFloat(40)
let H = CGFloat(20)

// TODO: use a Grid

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            HStack() {
                VStack() {
                    Diamond()
                        .stroke(.blue)
                        .frame(width:W, height: H)
                    Diamond()
                        .stroke(.blue)
                        .frame(width:W, height: H)
                }
                Spacer()
                Ellipse()
                    .stroke(.teal)
                    .frame(width:W, height: H)
                Spacer()
                Rectangle()
                    .stroke(.orange)
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



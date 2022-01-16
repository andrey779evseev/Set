//
//  StripeView.swift
//  Set
//
//  Created by Andrew on 1/11/22.
//

import SwiftUI

struct StripeView<SymbolShape>: View where SymbolShape: Shape {
    let numberOfStripes: Int = 4
    let borderLineWidth: CGFloat = 1
    
    let shape: SymbolShape
    let color: Color
    let spacingColor = Color.clear
    
    var body: some View {
        VStack(spacing: 0.5) {
            ForEach(0..<numberOfStripes) { _ in
                spacingColor
                color
            }
        }
        .mask(shape)
        .overlay(shape.stroke(color, lineWidth: borderLineWidth))
    }
}

struct StripeView_Previews: PreviewProvider {
    static var previews: some View {
        StripeView(shape: Diamond(), color: Color.red)
    }
}

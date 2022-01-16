//
//  DiamondView.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

struct ShapeView: View {
    let card: Card
    
    var body: some View {
        VStack {
            ForEach(0..<card.count.rawValue, id:\.self) { _ in
                switch card.figure {
                case .squiggles:
                    shadingFigure(shape: Squiggle())
                case .oval:
                    shadingFigure(shape: Capsule(style: .continuous))
                case .diamond:
                    shadingFigure(shape: Diamond())
                }
            }
        }
        .foregroundColor(card.swiftUiColor)
    }
    
    @ViewBuilder
    func shadingFigure<ShapeContent>(shape: ShapeContent) -> some View where ShapeContent: Shape {
        VStack {
            switch card.shading {
            case .striped:
                ZStack {
                    StripeView(shape: shape, color: card.swiftUiColor)
                    shape
                        .stroke(lineWidth: Constants.strokeWidth)
                }
            case .solid:
                shape
            case .stroked:
                shape
                    .stroke(lineWidth: Constants.strokeWidth)
            }
        }
        .aspectRatio(Constants.aspectRatio, contentMode: .fit)
        .frame(maxWidth: Constants.maxWidth)
    }
    
    private struct Constants {
        static let strokeWidth: CGFloat = 2
        static let aspectRatio: CGFloat = 4/2
        static let maxWidth: CGFloat = 80
    }
}

struct DiamondView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGameModel().cards.first!
        ShapeView(card: card)
    }
}

//
//  CardView.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.coronerRadius)
                if let matched = card.matched {
                    let color = matched ? Color.cyan : Color.orange
                    shape.fill()
                        .foregroundColor(color)
                        .opacity(Constants.shapeOpacity)
                    shape.strokeBorder(lineWidth: Constants.lineWidth)
                        .foregroundColor(color)
                        .shadow(
                            color: color,
                            radius: Constants.shadowRadius,
                            x: Constants.one,
                            y: Constants.one
                        )
                } else {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: Constants.lineWidth)
                        .foregroundColor(card.selected ? .blue : card.swiftUiColor)
                        .shadow(
                            color: card.selected ? .blue : .clear,
                            radius: card.selected ? Constants.shadowRadius : Constants.null,
                            x: Constants.one,
                            y: Constants.one
                        )
                }
                ShapeView(card: card)
                    .padding(Constants.shapePadding)
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: min(size.width, size.height) * Constants.fontScale)
    }
    
    private struct Constants {
        static let coronerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
        static let fontScale: Double = 0.7
        static let shadowRadius: CGFloat = 5
        static let null: CGFloat = 0
        static let one: CGFloat = 1
        static let shapeOpacity: CGFloat = 0.3
        static let shapePadding: CGFloat = 5
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGameModel().cards.first!
        CardView(card: card)
    }
}

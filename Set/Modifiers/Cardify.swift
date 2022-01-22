//
//  Cardify.swift
//  Memorize
//
//  Created by Andrew on 1/15/22.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    var card: Card
    var fill: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var animatableData: Card {
        get { card }
        set { card = newValue }
    }
    
    var degrees: Angle {
        if card.matched == false {
            return .degrees(-10)
        } else if card.matched == true {
            return .degrees(360)
        }
        return .degrees(0)
    }
    
    var animation: Animation? {
        if card.matched == false {
            return .spring().repeatCount(2)
        } else if card.matched == true {
            return .spring()
        }
        return nil
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.coronerRadius)
            if card.dealt {
                if let matched = card.matched {
                    let color = matched ? Color.green : Color.red
                    Group {
                        shape.fill()
                            .opacity(Constants.shapeOpacity)
                        shape.strokeBorder(lineWidth: Constants.lineWidth)
                            .shadow(
                                color: color,
                                radius: Constants.shadowRadius,
                                x: Constants.one,
                                y: Constants.one
                            )
                    }
                    .foregroundColor(color)
                    
                } else {
                    shape.fill()
                        .foregroundColor(card.selected ? .orange : .clear)
                        .opacity(card.selected ? Constants.shapeOpacity : 0)
                    shape.strokeBorder(lineWidth: Constants.lineWidth)
                        .foregroundColor(card.selected ? .orange : .blue)
                        .shadow(
                            color: card.selected ? .orange : .clear,
                            radius: card.selected ? Constants.shadowRadius : Constants.null,
                            x: Constants.one,
                            y: Constants.one
                        )
                }
            }
            if let matched = card.matched {
                if matched && !card.dealt {
                    shape.fill()
                        .foregroundColor(colorScheme == .light ? .white : .black)
                    shape.strokeBorder(lineWidth: Constants.lineWidth)
                        .foregroundColor(.blue)
                }
            }
            content
            if fill {
                shape.fill()
                    .foregroundColor(.blue)
            }
            
        }
        .rotationEffect(degrees)
        .animation(Animation.spring(), value: card.matched)
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


extension View {
    func cardify(card: Card, fill: Bool) -> some View {
        self.modifier(Cardify(card: card, fill: fill))
    }
}

//
//  CardView.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var fill: Bool = false
    
    var body: some View {
        ZStack {
            ShapeView(card: card)
                .padding(Constants.shapePadding)
        }
        .cardify(card: card, fill: fill)
    }
    
    private struct Constants {
        static let shapePadding: CGFloat = 5
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGameModel().cards.first!
        CardView(card: card)
    }
}

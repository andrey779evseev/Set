//
//  SetGameView.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        VStack {
            ScrollableAspectVGrid(items: game.cards, aspectRatio: Constants.aspectRatio) { card in
                CardView(card: card)
                    .padding(Constants.cardPadding)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
            HStack {
                Button {
                    game.newGame()
                } label: {
                    Text("New game")
                }
                Spacer()
                Button {
                    game.deal()
                } label: {
                    Text("Deal 3 cards")
                }
                .disabled(game.dealDisabled)
            }
            .padding(.horizontal)
        }
    }
    
    private struct Constants {
        static let aspectRatio: CGFloat = 2/3.5
        static let cardPadding: CGFloat = 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}

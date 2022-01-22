//
//  SetGameView.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    @Namespace private var dealingNamespace
    @State private var dealt = Set<UUID>()
    
    private func deal(_ card: Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: Card) -> Animation {
        var delay = 0.0
        if let index = game.showedCards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (Constants.totalDealDuration / Double(game.showedCards.count))
        }
        return Animation.easeInOut(duration: Constants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ScrollableAspectVGrid(items: game.showedCards, aspectRatio: Constants.aspectRatio) { card in
                    if isUnDealt(card) {
                        Color.clear
                    } else {
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .padding(Constants.cardPadding)
                            .transition(.asymmetric(insertion: .identity, removal: .scale))
                            .zIndex(zIndex(of: card))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    game.choose(card)
                                }
                            }
                    }
                    
                }
            }
            .padding(.bottom, 160)
            HStack {
                deck
                Spacer()
                restart
                Spacer()
                discardPile
            }
            .padding(.horizontal)
            .background(.regularMaterial)
        }
    }
    
    var deck: some View {
        ZStack {
            ForEach(game.cards.filter(isUnDealt)) { card in
                CardView(card: card, fill: true)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(maxWidth: Constants.unDealtWidth, maxHeight: Constants.unDealtHeight)
        .offset(x: 0, y: -20)
        .foregroundColor(.red)
        .onTapGesture {
            if dealt.isEmpty {
                for card in game.showedCards.filter(isUnDealt) {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
            } else {
                game.deal()
                for (index, card) in game.showedCards.filter(isUnDealt).enumerated() {
                    withAnimation(.easeInOut(duration: Constants.dealDuration).delay(Double(index)*(0.5 / 3))) {
                        deal(card)
                    }
                }
            }
        }
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(maxWidth: Constants.unDealtWidth, maxHeight: Constants.unDealtHeight)
        .offset(x: 0, y: -20)
    }
    
    var restart: some View {
        Button {
            withAnimation {
                dealt = []
                game.newGame()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill().foregroundColor(.white)
                    .opacity(0.3)
                Text("Restart")
            }
        }
        .frame(maxWidth: 100, maxHeight: 30)
    }
    
    private struct Constants {
        static let aspectRatio: CGFloat = 2/3.5
        static let cardPadding: CGFloat = 4
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let unDealtHeight: CGFloat = 160
        static let unDealtWidth = unDealtHeight * aspectRatio
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(game: game)
    }
}

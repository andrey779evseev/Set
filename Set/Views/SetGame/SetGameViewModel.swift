//
//  SetGameViewModel.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published var model = SetGameModel()
    
    func newGame() {
        model.restart()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func deal() {
        withAnimation(.easeInOut) {        
            model.replaceOrDealCards()
        }
    }
    
    var cards: [Card] {
        model.cards
    }
    
    var showedCards: [Card] {
        model.showedCards
    }
    
    var discardPile: [Card] {
        model.discardPile
    }
}

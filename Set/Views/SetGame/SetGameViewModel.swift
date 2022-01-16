//
//  SetGameViewModel.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import Foundation

class SetGameViewModel: ObservableObject {
    
    @Published var model = SetGameModel()
    
    func newGame() {
        model = SetGameModel()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func deal() {
        model.replaceOrDealCards()
    }
    
    var cards: [Card] {
        return model.cards
    }
    
    var dealDisabled: Bool {
        return model.dealDisabled
    }
}

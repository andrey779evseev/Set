//
//  Card.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import Foundation
import SwiftUI


struct SetGameModel {
    init() {
        deck = SetGameModel.createCards(count: .full)
        dealCards(12)
    }
    private var deck: [Card]
    private var matchedCards: [Card] = []
    private(set) var cards: [Card] = []
    
    var dealDisabled: Bool {
        return deck.isEmpty
    }
    
    private var selected: [Card] {
        return cards.filter { card in
            card.selected
        }
    }
    
    private var countShowed: Int = 12
    
    mutating func choose(_ card: Card) {
        if selected.count < 3 {
            if let index = oneById(id: card.id) {
                cards[index].selected.toggle()
                if selected.count == 3 {
                    let match = isSelectedSet()
                    selected.forEach { card in
                        if let index = oneById(id: card.id) {
                            cards[index].matched = match
                        }
                    }
                }
            }
        } else if selected.count == 3 {
            hideSelectedCards()
            if let index = oneById(id: card.id) {
                cards[index].selected = true
            }
        }
    }
    
    private mutating func hideSelectedCards() {
        selected.forEach { card in
            if let index = oneById(id: card.id) {
                if let matched = cards[index].matched {
                    if matched {
                        matchedCards.append(card)
                        cards.remove(at: index)
                        if !deck.isEmpty {
                            cards.insert(deck.first!, at: index)
                            deck.removeFirst()
                        }
                    } else {
                        cards[index].matched = false
                        cards[index].matched = nil
                        cards[index].selected = false
                    }
                }
            }
        }
    }
    
    mutating func replaceOrDealCards() {
        if selected.count == 3 {
            if isSelectedSet() {
                selected.forEach {card in
                    if let index = oneById(id: card.id) {
                        cards.remove(at: index)
                        if !deck.isEmpty {
                            cards.insert(deck.first!, at: index)
                            deck.removeFirst()
                        }
                    }
                }
                return
            }
        }
        dealCards()
    }
    
    private mutating func dealCards(_ count: Int = 3) {
        let array = deck.count > count ? Array(deck[0...count]) : deck
        cards.append(contentsOf: array)
        deck.removeSubrange(0...count)
    }
    
    private func oneById(id: UUID) -> Int? {
        if let index = cards.firstIndex(where: {$0.id == id}) {
            return index
        }
        return nil
    }
    
    private func isSelectedSet() -> Bool {
        var figures = Set<Card.FigureFeature>()
        var colors = Set<Card.ColorFeature>()
        var shadings = Set<Card.ShadingFeature>()
        var counts = Set<Card.CountFeature>()
        
        selected.forEach { card in
            figures.insert(card.figure)
            colors.insert(card.color)
            shadings.insert(card.shading)
            counts.insert(card.count)
        }
        
        if figures.count == 2 || colors.count == 2 ||
            shadings.count == 2 || counts.count == 2 {
            return false
        }
        return true
    }
    
    private static func createCards(count: DecCardsCountOptions = .full) -> [Card] {
        var cards = [Card]()
        for color in Card.ColorFeature.allCases {
            for shading in Card.ShadingFeature.allCases {
                for count in Card.CountFeature.allCases {
                    for figure in Card.FigureFeature.allCases {
                        cards.append(Card(color: color, figure: figure, shading: shading, count: count))
                    }
                }
            }
        }
        return Array(cards[0..<count.rawValue]).shuffled()
    }
    
    enum DecCardsCountOptions: Int {
        case nine = 9
        case twentySeven = 27
        case full = 81
    }
}

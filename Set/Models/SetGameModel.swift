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
        cards = SetGameModel.createCards(count: .full)
        dealCards(12)
    }
    private(set) var cards: [Card] = []
    private(set) var discardPile: [Card] = []
    
    private var selected: [Card] {
        return cards.filter { card in
            card.selected && card.dealt
        }
    }
    var deck: [Card] {
        cards.filter {$0.dealt == false && ($0.matched == nil || $0.matched == false)}
    }
    
    var showedCards: [Card] {
        return cards.filter {$0.dealt == true}
    }
    
    private var countShowed: Int = 12
    
    mutating func restart() {
        for _ in discardPile.indices {
            cards.append(discardPile[0])
            discardPile.remove(at: 0)
        }
        for index in cards.indices {
            cards[index].matched = nil
            cards[index].selected = false
            cards[index].dealt = false
        }
        cards.shuffle()
        dealCards(12)
    }
    
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
                        discardCard(at: index)
                    } else {
                        deselectCard(index: index)
                    }
                }
            }
        }
    }
    
    private mutating func deselectCard(card: Card? = nil, index: Int? = nil) {
        if card != nil && index == nil {
            if let index = oneById(id: card!.id) {
                cards[index].selected = false
                cards[index].matched = nil
            }
        } else {
            cards[index!].selected = false
            cards[index!].matched = nil
        }
    }
    
    private mutating func discardCard(at index: Int) {
        cards[index].dealt = false
        discardPile.append(cards.remove(at: index))
    }
    
    mutating func replaceOrDealCards() {
        if selected.count == 3 {
            if isSelectedSet() {
                selected.forEach {card in
                    if let index = oneById(id: card.id) {
                        discardCard(at: index)
                        if !deck.isEmpty {
                            if let i = oneById(id: deck.first!.id) {
                                cards.move(from: i, to: index)
                                cards[index].dealt = true
                            }
                        }
                    }
                }
            } else {
                selected.forEach { card in
                    deselectCard(card: card)
                }
                dealCards()
            }
        } else {
            dealCards()
        }
    }
    
    private mutating func dealCards(_ count: Int = 3) {
        var _count = 0
        for card in cards.filter({!$0.dealt && !($0.matched ?? false)}) {
            if let index = oneById(id: card.id) {
                cards[index].dealt = true
                _count += 1
            }
            if _count == count {
                break
            }
        }
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

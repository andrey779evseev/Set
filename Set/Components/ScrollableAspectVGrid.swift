//
//  ScrollableAspectVGrid.swift
//  Memorize
//
//  Created by Andrew on 1/7/22.
//

import SwiftUI

struct ScrollableAspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
                ScrollView {
                    let width: CGFloat = widthThatFits(in: geometry.size)
                    LazyVGrid(columns: [adaptiveGridItem(width)], spacing: 0) {
                        ForEach(items) { item in
                            content(item)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 5)
            }
    }
    
    private func adaptiveGridItem(_ width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(in size: CGSize) -> CGFloat {
        var columnCount = 1
        var rowCount = items.count
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / aspectRatio
            if CGFloat(rowCount) * itemHeight < size.height || (60...70).contains(itemWidth)  {
                break
            }
            columnCount += 1
            rowCount = (items.count + (columnCount - 1)) / columnCount
        } while columnCount < items.count
        if columnCount > items.count {
            columnCount = items.count
        }
        return floor((size.width - 10) / CGFloat(columnCount))
    }
}

struct AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        let cards = SetGameModel().cards
        ScrollableAspectVGrid(items: cards, aspectRatio: 2/3.5, content: { card in
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    //                        game.choose(card)
                }
        })
    }
}

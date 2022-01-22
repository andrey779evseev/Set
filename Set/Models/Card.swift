//
//  Card.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import Foundation
import SwiftUI


struct Card: Identifiable, Equatable {
    init(color: ColorFeature, figure: FigureFeature, shading: ShadingFeature, count: CountFeature) {
        self.id = UUID.init()
        self.color = color
        self.figure = figure
        self.shading = shading
        self.count = count
    }
    
    var id: UUID
    var color: ColorFeature
    var figure: FigureFeature
    var shading: ShadingFeature
    var count: CountFeature
    var selected: Bool = false
    var matched: Bool?
    var dealt: Bool = false
    
    var swiftUiColor: Color {
        switch self.color {
        case .red:
            return .red
        case .purple:
            return .purple
        case .green:
            return .green
        }
    }
    
    enum ColorFeature: CaseIterable {
        case red
        case green
        case purple
    }
    
    enum ShadingFeature: CaseIterable {
        case solid
        case striped
        case stroked
    }
    
    enum CountFeature: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum FigureFeature: CaseIterable {
        case oval
        case squiggles
        case diamond
    }
}

//
//  SetApp.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        let game = SetGameViewModel()
        WindowGroup {
            SetGameView(game: game)
        }
    }
}

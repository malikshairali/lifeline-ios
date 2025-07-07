//
//  LifelineApp.swift
//  Lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import SwiftUI
import SwiftData

@main
struct LifelineApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Album.self)
    }
}

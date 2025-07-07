//
//  HomeViewModel.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import SwiftUI
import SwiftData

class HomeViewModel: ObservableObject {

    func createAlbum(
        context: ModelContext,
        name: String,
        start: Date,
        end: Date
    ) {
        let album = Album(title: name, startDate: start, endDate: end, coverImage: "")
        context.insert(album)
    }
}

//
//  HomeViewModel.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var error: String? = nil

    func createAlbum(name: String, start: Date, end: Date) {
        // Stub: pretend we check PhotoKit and found photos
//        let foundPhotos = Bool.random() // Randomly fake if photos found
//
//        if foundPhotos {
            let newAlbum = Album(
                id: UUID(),
                title: name,
                startDate: start,
                endDate: end,
                coverImageName: "placeholder" // Replace later with real photo
            )
            albums.append(newAlbum)
//        } else {
//            error = "No photos found in selected date range."
//        }
    }

    func clearError() {
        error = nil
    }
}

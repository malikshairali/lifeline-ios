//
//  Album.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import Foundation
import SwiftData

@Model
final class Album {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var coverImage: String

    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date, coverImage: String) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.coverImage = coverImage
    }
}

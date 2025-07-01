//
//  Album.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import Foundation

struct Album: Identifiable, Hashable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    let coverImageName: String
}

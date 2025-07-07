//
//  AlbumCard.swift
//  Lifeline
//
//  Created by Malik Gohar on 06/07/2025.
//

import SwiftUI

struct AlbumCard: View {
    var album: Album
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(1.25, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .clipped()

                Text(album.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(album.startDate, formatter: dateFormatter) - \(album.endDate, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain) // keeps native tap highlight, no default blue
        .contentShape(Rectangle()) // makes whole card tappable
    }
}


#Preview {
    AlbumCard(
        album: Album(
            id: UUID(),
            title: "Title",
            startDate: Date(),
            endDate: Date(),
            coverImage: ""
        )
    ){}
}

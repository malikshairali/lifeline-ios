//
//  HomeView.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCreateSheet = false
    @State private var selectedAlbum: Album? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.albums.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("Start your visual story")
                            .font(.title2)
                        Text("Tap + to create your first album.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    List(viewModel.albums) { album in
                        NavigationLink(value: album) {
                            HStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                        .font(.headline)
                                    Text("\(album.startDate, formatter: dateFormatter) - \(album.endDate, formatter: dateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lifeline")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showCreateSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 56, height: 56)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showCreateSheet) {
                CreateAlbumSheet { name, start, end in
                    viewModel.createAlbum(name: name, start: start, end: end)
                    if viewModel.error == nil {
                        showCreateSheet = false
                    }
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { _ in viewModel.clearError() }
            )) {
                Alert(title: Text("Error"), message: Text(viewModel.error ?? ""), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(for: Album.self) { album in
                TimelineView(album: album)
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .medium
    return f
}()

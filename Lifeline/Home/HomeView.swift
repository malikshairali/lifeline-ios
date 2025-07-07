//
//  HomeView.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Query(sort: \Album.startDate) private var albums: [Album]
    @Environment(\.modelContext) private var context
    @State private var showCreateSheet = false
    @State private var selectedAlbum: Album? = nil
    @State private var isFabVisible: Bool = true
    @State private var lastScrollOffset: CGFloat = 0
    @State private var autoHideActive = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetKey.self,
                                    value: geo.frame(in: .global).minY
                                )
                        }
                        .frame(height: 0)
                        if albums.isEmpty {
                            Spacer(minLength: 100)
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
                            ForEach(albums) { album in
                                AlbumCard(album: album) {
                                    selectedAlbum = album
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                .background(Color(.systemBackground))
                .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
                    if !autoHideActive {
                        autoHideActive = true
                        lastScrollOffset = newOffset
                        return
                    }

                    let delta = newOffset - lastScrollOffset
                    if delta < -10 {
                        withAnimation(.easeInOut) { isFabVisible = false }
                    } else if delta > 10 {
                        withAnimation(.easeInOut) { isFabVisible = true }
                    }
                    lastScrollOffset = newOffset
                }

                // Floating FAB
                Button(action: { showCreateSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundColor(.accentColor)
                }
                .padding()
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                .opacity(isFabVisible ? 1 : 0)
                .offset(y: isFabVisible ? 0 : 100)
            }
            .navigationTitle("Lifeline")
            .sheet(isPresented: $showCreateSheet) {
                CreateAlbumSheet { name, start, end in
                    viewModel.createAlbum(context: context, name: name, start: start, end: end)
//                    if viewModel.error == nil {
//                        showCreateSheet = false
//                    }
                    autoHideActive = false
                    showCreateSheet = false
                }
            }
            .navigationDestination(item: $selectedAlbum) { album in
                TimelineView(album: album)
            }
//            .alert(
//                isPresented: Binding<Bool>(
//                    get: { viewModel.error != nil },
//                    set: { _ in viewModel.clearError() }
//                )
//            ) {
//                Alert(
//                    title: Text("Error"),
//                    message: Text(viewModel.error ?? ""),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

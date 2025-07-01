//
//  TimelineView.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import Photos
import SwiftUI

struct TimelineView: View {
    let album: Album
    @State private var photosByDay: [(date: Date, photos: [UIImage])] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            if photosByDay.isEmpty {
                ProgressView("Loading...")
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                    .onAppear { loadPhotos() }
            } else {
                if #available(iOS 17.0, *) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(photosByDay.enumerated()), id: \.element.date) { index, dayGroup in
                                let hasPreviousDay = index > 0
                                let hasNextDay = index < photosByDay.count - 1
                                
                                DayPhotosView(
                                    date: dayGroup.date,
                                    displayLeadingTimeline: hasPreviousDay,
                                    displayTrailingTimeline: hasNextDay,
                                    images: dayGroup.photos
                                )
                                    .frame(height: UIScreen.main.bounds.height)
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .ignoresSafeArea()
                } else {
                    // Fallback on earlier versions
                }
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .padding(14)
                    .background(.black.opacity(0.2), in: Circle())
                    .padding(.top, UIScreen.main.bounds.height * 0.08)
                    .padding([.trailing, .leading], 16)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

    func loadPhotos() {
        let manager = PHCachingImageManager()
        let targetSize = UIScreen.main.bounds.size

        DispatchQueue.global(qos: .userInitiated).async {
            fetchPhotosBetween(start: album.startDate, end: album.endDate) { assets in
                let grouped = Dictionary(grouping: assets) { asset in
                    Calendar.current.startOfDay(for: asset.creationDate ?? Date())
                }
                let sorted = grouped.sorted(by: { $0.key > $1.key })

                var result: [(Date, [UIImage])] = []
                let outerGroup = DispatchGroup()

                for (date, assets) in sorted {
                    var images: [UIImage] = []
                    let innerGroup = DispatchGroup()

                    for asset in assets {
                        innerGroup.enter()
                        manager.requestImage(
                            for: asset,
                            targetSize: targetSize,
                            contentMode: .aspectFill,
                            options: nil
                        ) { img, _ in
                            if let img = img { images.append(img) }
                            innerGroup.leave()
                        }
                    }

                    outerGroup.enter()
                    innerGroup.notify(queue: .global()) {
                        if !images.isEmpty {
                            result.append((date, images))
                        }
                        outerGroup.leave()
                    }
                }

                outerGroup.notify(queue: .main) {
                    photosByDay = result
                }
            }
        }
    }
}

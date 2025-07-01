//
//  DayPhotosView.swift
//  Lifeline
//
//  Created by Malik Gohar on 29/06/2025.
//

import Photos
import SwiftUI

struct DayPhotosView: View {
    let date: Date
    let displayLeadingTimeline: Bool
    let displayTrailingTimeline: Bool
    let images: [UIImage]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView {
                ForEach(images, id: \.self) { img in
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                        )
                        .clipped()
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .ignoresSafeArea()

            VStack(alignment: .trailing, spacing: 0) {
                if displayLeadingTimeline {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))  // base dark line
                        .frame(
                            width: 4,
                            height: UIScreen.main.bounds.height * 0.085
                        )
                        .border(Color.white.opacity(0.5), width: 0.2)
//                        .overlay(
//                            Rectangle()
//                                .fill(Color.white.opacity(0.2))  // solid overlay on top
//                                .frame(width: 4)  // thinner white center stripe
//                        )
                        .padding(.trailing, 40)
                }

                Text(date, style: .date)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        .black.opacity(0.3),
                        in: RoundedRectangle(cornerRadius: 8)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(
                            Color.white.opacity(0.7),
                            lineWidth: 0.2
                        )
                    )
                    .padding([.trailing, .leading], 16)
                    .padding(
                        .top,
                        displayLeadingTimeline
                            ? 0 : UIScreen.main.bounds.height * 0.085
                    )

                if displayTrailingTimeline {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 4)
                        .border(Color.white.opacity(0.5), width: 0.2)
//                        .overlay(
//                            Rectangle()
//                                .fill(Color.white.opacity(0.2))
//                                .frame(width: 4)
//                        )
                        .padding(.trailing, 40)
                }
            }
        }
    }
}

//
//  VideoRowView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//
import SwiftUI

struct VideoRowView: View {
    let video: Video
    @ObservedObject var viewModel: VideoViewModel

    var body: some View {
        NavigationLink(destination: VideoPlayerView(video: video, viewModel: viewModel)) {
            HStack {
                // Thumbnail
                AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 60)
                .cornerRadius(8)

                // Video Info
                VStack(alignment: .leading) {
                    Text(video.title)
                        .font(.headline)
                    Text(video.duration)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

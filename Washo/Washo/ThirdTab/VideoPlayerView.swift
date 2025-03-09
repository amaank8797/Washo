//
//  VideoPlayerView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let video: Video
    @ObservedObject var viewModel: VideoViewModel
    @State private var player: AVPlayer?
    @State private var isWatched: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Video Player
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                        viewModel.fetchWatchedStatus(for: video) { watched in
                            isWatched = watched
                        }
                    }
                    .onDisappear {
                        player.pause()
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 8)
            } else {
                ProgressView("Loading Video...")
            }

            Spacer()

            // Watched Checkbox
            HStack {
                Button(action: {
                    viewModel.toggleWatched(for: video, isWatched: !isWatched)
                    isWatched.toggle()
                }) {
                    HStack {
                        Image(systemName: isWatched ? "checkmark.square.fill" : "square")
                            .foregroundColor(isWatched ? .green : .gray)
                        Text(isWatched ? "Mark as Unwatched" : "Mark as Watched")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isWatched ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()

            // Admin Delete Button
            if viewModel.isAdmin {
                Button(action: {
                    deleteVideo()
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("Delete Video")
                            .foregroundColor(.red)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }

            Spacer()
        }
        .padding()
        .onAppear {
            if let url = URL(string: video.videoURL) {
                player = AVPlayer(url: url)
            }
        }
        .navigationTitle(video.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Delete Video
    private func deleteVideo() {
        viewModel.deleteVideo(video)
        presentationMode.wrappedValue.dismiss() // Go back after deletion
    }
}

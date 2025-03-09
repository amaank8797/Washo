//
//  VideoListView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI

struct VideoListView: View {
    @StateObject private var viewModel = VideoViewModel()
    @State private var showUploadSheet = false

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Loading videos...")
                    } else if viewModel.videos.isEmpty {
                        noVideosView
                    } else {
                        videoList
                    }
                }
                .navigationTitle("Training Videos")
            }

            // Floating + Button for Admins
            if viewModel.isAdmin {
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        Button(action: {
                            showUploadSheet.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 60, height: 60)
                                        .shadow(radius: 10)
                                )
                        }
                        .padding()
                        .sheet(isPresented: $showUploadSheet) {
                            VideoUploadView(viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }

    private var noVideosView: some View {
        VStack {
            Image(systemName: "film.slash")
                .font(.system(size: 64))
                .foregroundColor(.gray)
                .padding()

            Text("No Videos")
                .font(.title3)
                .foregroundColor(.gray)
        }
    }

    private var videoList: some View {
        List(viewModel.videos) { video in
            VideoRowView(video: video, viewModel: viewModel)
        }
        .listStyle(.insetGrouped)
    }
}


#Preview {
    VideoListView()
}

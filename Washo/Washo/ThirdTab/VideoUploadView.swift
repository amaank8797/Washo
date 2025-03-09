//
//  VideoUploadView.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import SwiftUI
import PhotosUI

struct VideoUploadView: View {
    @ObservedObject var viewModel: VideoViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var selectedVideoItem: PhotosPickerItem?
    @State private var videoData: Data?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Video Title")) {
                        TextField("Enter video title", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }

                    Section(header: Text("Select Video")) {
                        PhotosPicker(selection: $selectedVideoItem, matching: .videos, photoLibrary: .shared()) {
                            Text("Pick a video")
                                .foregroundColor(.blue)
                        }
                        .onChange(of: selectedVideoItem) { newValue in
                            Task {
                                if let videoData = try? await newValue?.loadTransferable(type: Data.self) {
                                    self.videoData = videoData
                                }
                            }
                        }

                        if videoData != nil {
                            Text("Video Selected")
                                .foregroundColor(.green)
                        }
                    }

                    if viewModel.uploadProgress > 0 {
                        ProgressView(value: viewModel.uploadProgress, total: 100)
                            .padding()
                    }
                }

                Spacer()

                Button(action: uploadVideo) {
                    Text("Upload")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(videoData == nil || title.isEmpty)
            }
            .navigationTitle("Upload Video")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func uploadVideo() {
        guard let videoData = videoData else { return }

        Task {
            await viewModel.uploadVideo(title: title, videoData: videoData)
            dismiss()
        }
    }
}

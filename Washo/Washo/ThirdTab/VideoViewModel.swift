//
//  VideoViewModel.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class VideoViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var uploadProgress: Double = 0.0
    @Published var isLoading: Bool = true
    @Published var isAdmin: Bool = false

    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let auth = Auth.auth()

    init() {
        Task {
            await checkUserRole()
            fetchVideos()
        }
    }

    /// Check if the current user is an admin
    private func checkUserRole() async {
        guard let userID = auth.currentUser?.uid else { return }
        do {
            let document = try await db.collection("users").document(userID).getDocument()
            if let role = document.data()?["role"] as? String {
                isAdmin = (role == "admin")
            }
        } catch {
            print("Error checking user role: \(error.localizedDescription)")
        }
    }

    /// Fetch videos from Firestore in real-time
    func fetchVideos() {
        db.collection("videos").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isLoading = false

            if let error = error {
                print("Error fetching videos: \(error.localizedDescription)")
                return
            }

            self.videos = snapshot?.documents.compactMap { document in
                try? document.data(as: Video.self)
            } ?? []
        }
    }

    /// Upload video
    func uploadVideo(title: String, videoData: Data) async {
        let videoID = UUID().uuidString
        let videoRef = storage.child("videos/\(videoID).mp4")

        do {
            // Upload the video with async/await
            let metadata = StorageMetadata()
            metadata.contentType = "video/mp4"

            let uploadTask = videoRef.putData(videoData, metadata: metadata)

            // Monitor progress
            uploadTask.observe(.progress) { [weak self] snapshot in
                guard let self = self else { return }
                self.uploadProgress = Double(snapshot.progress?.fractionCompleted ?? 0) * 100
            }

            // Await upload completion
            _ = try await withCheckedThrowingContinuation { continuation in
                uploadTask.observe(.success) { _ in
                    continuation.resume(returning: ())
                }
                uploadTask.observe(.failure) { error in
                    continuation.resume(throwing: error as! any Error)
                }
            }

            // Get video URL
            let videoURL = try await videoRef.downloadURL().absoluteString

            // Save metadata to Firestore
            let newVideo = Video(id: videoID, title: title, thumbnailURL: "", videoURL: videoURL, duration: "0:00", isWatched: false)
            try db.collection("videos").document(videoID).setData(from: newVideo)

            // Append to local list
            videos.append(newVideo)

        } catch {
            print("Error uploading video: \(error.localizedDescription)")
        }
    }

    /// Toggle watched status for the current user
    func toggleWatched(for video: Video, isWatched: Bool) {
        guard let userID = auth.currentUser?.uid else { return }
        let videoRef = db.collection("videos").document(video.id).collection("watched").document(userID)

        videoRef.setData(["isWatched": isWatched]) { error in
            if let error = error {
                print("Error toggling watched status: \(error.localizedDescription)")
            }
        }
    }

    /// Fetch watched status for the current user
    func fetchWatchedStatus(for video: Video, completion: @escaping (Bool) -> Void) {
        guard let userID = auth.currentUser?.uid else { return }
        let videoRef = db.collection("videos").document(video.id).collection("watched").document(userID)

        videoRef.getDocument { document, error in
            if let error = error {
                print("Error fetching watched status: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let document = document, let data = document.data(), let isWatched = data["isWatched"] as? Bool {
                completion(isWatched)
            } else {
                completion(false)
            }
        }
    }

    /// Delete video
    func deleteVideo(_ video: Video) {
        let videoRef = db.collection("videos").document(video.id)
        let storageRef = Storage.storage().reference(forURL: video.videoURL)

        // Delete Firestore document
        videoRef.delete { [weak self] error in
            if let error = error {
                print("Error deleting video from Firestore: \(error.localizedDescription)")
                return
            }

            // Try to delete video from Storage
            storageRef.delete { error in
                if let error = error {
                    if (error as NSError).code == StorageErrorCode.objectNotFound.rawValue {
                        print("Video not found in Storage. Skipping deletion.")
                    } else {
                        print("Error deleting video from Storage: \(error.localizedDescription)")
                    }
                } else {
                    print("Video successfully deleted from Storage.")
                }

                // Refresh video list
                self?.fetchVideos()
            }
        }
    }
}

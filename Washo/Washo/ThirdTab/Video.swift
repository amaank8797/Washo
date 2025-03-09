//
//  Video.swift
//  Washo
//
//  Created by Amaan Amaan on 05/01/25.
//

import Foundation

struct Video: Identifiable, Codable {
    let id: String
    let title: String
    let thumbnailURL: String
    let videoURL: String
    let duration: String
    var isWatched: Bool = false
    
    init(id: String = UUID().uuidString, title: String, thumbnailURL: String, videoURL: String, duration: String, isWatched: Bool = false) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.duration = duration
        self.isWatched = isWatched
    }
}


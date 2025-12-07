//
//  Production.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class Production {
    var id: UUID
    var title: String
    var synopsis: String
    var genre: String
    var duration: TimeInterval // in seconds
    var releaseDate: Date
    var posterURL: String?
    var videoURL: String?
    var storyIdea: StoryIdea?
    var tasteProfileTags: [String] // genre/keyword tags from taste analysis
    var createdAt: Date
    var status: ProductionStatus
    
    init(
        id: UUID = UUID(),
        title: String,
        synopsis: String,
        genre: String,
        duration: TimeInterval,
        releaseDate: Date = Date(),
        posterURL: String? = nil,
        videoURL: String? = nil,
        storyIdea: StoryIdea? = nil,
        tasteProfileTags: [String] = [],
        createdAt: Date = Date(),
        status: ProductionStatus = .released
    ) {
        self.id = id
        self.title = title
        self.synopsis = synopsis
        self.genre = genre
        self.duration = duration
        self.releaseDate = releaseDate
        self.posterURL = posterURL
        self.videoURL = videoURL
        self.storyIdea = storyIdea
        self.tasteProfileTags = tasteProfileTags
        self.createdAt = createdAt
        self.status = status
    }
}

enum ProductionStatus: String, Codable {
    case inProgress = "in_progress"
    case queued = "queued"
    case released = "released"
    case archived = "archived"
}


//
//  StoryIdea.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class StoryIdea {
    var id: UUID
    var logline: String
    var title: String
    var synopsis: String
    var genre: String
    var themes: [String]
    var characterObjectives: [String] // Stanislavski objectives
    var sceneBeats: [SceneBeat]
    var tasteProfileTags: [String]
    var createdAt: Date
    var status: StoryStatus
    
    init(
        id: UUID = UUID(),
        logline: String,
        title: String,
        synopsis: String,
        genre: String,
        themes: [String] = [],
        characterObjectives: [String] = [],
        sceneBeats: [SceneBeat] = [],
        tasteProfileTags: [String] = [],
        createdAt: Date = Date(),
        status: StoryStatus = .generated
    ) {
        self.id = id
        self.logline = logline
        self.title = title
        self.synopsis = synopsis
        self.genre = genre
        self.themes = themes
        self.characterObjectives = characterObjectives
        self.sceneBeats = sceneBeats
        self.tasteProfileTags = tasteProfileTags
        self.createdAt = createdAt
        self.status = status
    }
}

struct SceneBeat: Codable {
    var sceneNumber: Int
    var objective: String // Stanislavski objective
    var obstacle: String
    var tactics: [String]
    var beatDescription: String
    var emotionalMoment: Bool // For pause pattern analysis
}

enum StoryStatus: String, Codable {
    case generated = "generated"
    case inDevelopment = "in_development"
    case approved = "approved"
    case inProduction = "in_production"
    case completed = "completed"
}


//
//  TasteProfile.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class TasteProfile {
    var id: UUID
    var userId: String
    var genrePreferences: [String: Double] // genre -> preference score (0.0 - 1.0)
    var themeClusters: [String] // e.g., "time manipulation", "identity crisis"
    var moodVectors: [String] // emotional preferences
    var likedProductions: [UUID]
    var skippedProductions: [UUID]
    var completedProductions: [UUID]
    var createdAt: Date
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        userId: String = "default",
        genrePreferences: [String: Double] = [:],
        themeClusters: [String] = [],
        moodVectors: [String] = [],
        likedProductions: [UUID] = [],
        skippedProductions: [UUID] = [],
        completedProductions: [UUID] = [],
        createdAt: Date = Date(),
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.genrePreferences = genrePreferences
        self.themeClusters = themeClusters
        self.moodVectors = moodVectors
        self.likedProductions = likedProductions
        self.skippedProductions = skippedProductions
        self.completedProductions = completedProductions
        self.createdAt = createdAt
        self.lastUpdated = lastUpdated
    }
    
    func updateFromSelections(movieGenres: [String], movieKeywords: [String]) {
        // Update genre preferences based on selections
        for genre in movieGenres {
            genrePreferences[genre, default: 0.0] += 0.1
        }
        
        // Update theme clusters from keywords
        themeClusters.append(contentsOf: movieKeywords)
        themeClusters = Array(Set(themeClusters)) // Remove duplicates
        
        lastUpdated = Date()
    }
}


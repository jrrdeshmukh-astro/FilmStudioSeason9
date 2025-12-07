//
//  TasteAnalysisService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

class TasteAnalysisService {
    
    /// Build taste profile from local movies (no API needed)
    func buildTasteProfileFromLocalMovies(_ movies: [LocalMovie]) -> TasteProfile {
        var genreScores: [String: Double] = [:]
        var themes: [String] = []
        
        for movie in movies {
            // Update genre preferences
            genreScores[movie.genre, default: 0.0] += 1.0
            
            // Extract themes from user description if available
            if let description = movie.userDescription {
                let keywords = extractKeywords(from: description)
                themes.append(contentsOf: keywords)
            }
            
            // Extract themes from title (simple keyword extraction)
            let titleKeywords = extractKeywords(from: movie.title)
            themes.append(contentsOf: titleKeywords)
        }
        
        // Normalize genre scores to 0.0-1.0 range
        let maxScore = genreScores.values.max() ?? 1.0
        for key in genreScores.keys {
            genreScores[key] = (genreScores[key] ?? 0.0) / maxScore
        }
        
        let profile = TasteProfile(
            genrePreferences: genreScores,
            themeClusters: Array(Set(themes))
        )
        
        return profile
    }
    
    func updateTasteProfile(
        _ profile: TasteProfile,
        from watchState: MediaWatchState,
        with productions: [Production]
    ) {
        // Analyze completed productions
        for productionId in watchState.completedProductions {
            if let production = productions.first(where: { $0.id == productionId }) {
                // Update genre preferences
                profile.genrePreferences[production.genre, default: 0.0] += 0.05
                
                // Update theme clusters
                profile.themeClusters.append(contentsOf: production.tasteProfileTags)
            }
        }
        
        // Analyze skipped productions (decrease preference)
        for productionId in watchState.skippedProductions {
            if let production = productions.first(where: { $0.id == productionId }) {
                profile.genrePreferences[production.genre, default: 0.0] -= 0.05
            }
        }
        
        // Analyze liked productions (strong preference signal)
        for productionId in watchState.likedProductions {
            if let production = productions.first(where: { $0.id == productionId }) {
                profile.genrePreferences[production.genre, default: 0.0] += 0.1
                profile.themeClusters.append(contentsOf: production.tasteProfileTags)
            }
        }
        
        // Remove duplicates from themes
        profile.themeClusters = Array(Set(profile.themeClusters))
        profile.lastUpdated = Date()
    }
    
    private func extractKeywords(from text: String) -> [String] {
        // Simplified keyword extraction
        // In production, use NLP or keyword extraction service
        let commonWords = Set(["the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for", "of", "with", "by"])
        let words = text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty && !commonWords.contains($0) && $0.count > 3 }
        
        return Array(Set(words)).prefix(10).map { String($0) }
    }
}


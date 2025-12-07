//
//  TasteAnalysisService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

class TasteAnalysisService {
    
    func buildTasteProfile(from movies: [MovieMetadata]) -> TasteProfile {
        var genreScores: [String: Double] = [:]
        var themes: [String] = []
        
        // Map TMDb genre IDs to genre names (simplified - in production, use full genre map)
        let genreMap: [Int: String] = [
            28: "Action", 12: "Adventure", 16: "Animation",
            35: "Comedy", 80: "Crime", 99: "Documentary",
            18: "Drama", 10751: "Family", 14: "Fantasy",
            36: "History", 27: "Horror", 10402: "Music",
            9648: "Mystery", 10749: "Romance", 878: "Science Fiction",
            10770: "TV Movie", 53: "Thriller", 10752: "War", 37: "Western"
        ]
        
        for movie in movies {
            // Update genre preferences
            for genreID in movie.genreIDs {
                if let genreName = genreMap[genreID] {
                    genreScores[genreName, default: 0.0] += 1.0
                }
            }
            
            // Extract themes from overview (simplified - in production, use NLP)
            if let overview = movie.overview {
                let keywords = extractKeywords(from: overview)
                themes.append(contentsOf: keywords)
            }
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


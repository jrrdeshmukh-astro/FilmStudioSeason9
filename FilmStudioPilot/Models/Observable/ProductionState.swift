//
//  ProductionState.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import Observation

@Observable
final class ProductionState {
    var activeProductions: [Production] = []
    var queuedStories: [StoryIdea] = []
    var recentlyReleased: [Production] = []
    var isGenerating: Bool = false
    
    func addToQueue(_ story: StoryIdea) {
        queuedStories.append(story)
    }
    
    func moveToActive(_ production: Production) {
        activeProductions.append(production)
        if let index = queuedStories.firstIndex(where: { $0.id == production.storyIdea?.id }) {
            queuedStories.remove(at: index)
        }
    }
    
    func releaseProduction(_ production: Production) {
        if let index = activeProductions.firstIndex(where: { $0.id == production.id }) {
            activeProductions.remove(at: index)
        }
        recentlyReleased.append(production)
        production.status = .released
        
        // Keep only last 20 recently released
        if recentlyReleased.count > 20 {
            recentlyReleased.removeFirst()
        }
    }
}


//
//  MediaStateObserver.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import Combine

@MainActor
class MediaStateObserver: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let productionEngine: ProductionEngineService
    private let productionState: ProductionState
    
    init(
        watchState: MediaWatchState,
        productionEngine: ProductionEngineService,
        productionState: ProductionState
    ) {
        self.productionEngine = productionEngine
        self.productionState = productionState
        
        // Observe watch progress for completion
        observeCompletion(watchState: watchState)
        
        // Observe skip patterns
        observeSkipPatterns(watchState: watchState)
        
        // Observe repeat viewing
        observeRepeatViewing(watchState: watchState)
        
        // Observe pause patterns
        observePausePatterns(watchState: watchState)
    }
    
    private func observeCompletion(watchState: MediaWatchState) {
        // In a real implementation, use Combine to observe changes
        // For v1, we'll use a simpler approach with onChange
    }
    
    private func observeSkipPatterns(watchState: MediaWatchState) {
        // Observe when user skips multiple productions
    }
    
    private func observeRepeatViewing(watchState: MediaWatchState) {
        // Observe when user watches same production multiple times
    }
    
    private func observePausePatterns(watchState: MediaWatchState) {
        // Observe pause moments for emotional beat analysis
    }
    
    func handleCompletion(
        productionId: UUID,
        tasteProfile: TasteProfile
    ) async {
        // Generate new story based on completion
        let story = await productionEngine.generateStory(
            from: tasteProfile,
            trigger: .completion
        )
        
        let production = productionEngine.createProduction(from: story)
        productionState.addToQueue(story)
        productionState.moveToActive(production)
    }
    
    func handleSkipStreak(
        count: Int,
        tasteProfile: TasteProfile
    ) async {
        if count >= 3 {
            // User skipped 3+ in a row, generate different style
            let story = await productionEngine.generateStory(
                from: tasteProfile,
                trigger: .skip
            )
            
            let production = productionEngine.createProduction(from: story)
            productionState.addToQueue(story)
            productionState.moveToActive(production)
        }
    }
    
    func handleRepeatView(
        productionId: UUID,
        viewCount: Int,
        tasteProfile: TasteProfile
    ) async {
        if viewCount >= 2 {
            // User watched same production multiple times, generate similar
            let story = await productionEngine.generateStory(
                from: tasteProfile,
                trigger: .repeatView
            )
            
            let production = productionEngine.createProduction(from: story)
            productionState.addToQueue(story)
            productionState.moveToActive(production)
        }
    }
}


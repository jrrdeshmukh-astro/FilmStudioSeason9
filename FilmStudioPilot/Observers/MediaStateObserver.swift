//
//  MediaStateObserver.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import Observation

@MainActor
@Observable
class MediaStateObserver {
    private let productionEngine: ProductionEngineService
    private let productionState: ProductionState
    private var lastWatchProgress: Double = 0.0
    private var lastSkippedCount: Int = 0
    private var lastPauseCount: Int = 0
    
    init(
        watchState: MediaWatchState,
        productionEngine: ProductionEngineService,
        productionState: ProductionState
    ) {
        self.productionEngine = productionEngine
        self.productionState = productionState
        
        // Start observing state changes
        Task {
            await observeStateChanges(watchState: watchState)
        }
    }
    
    private func observeStateChanges(watchState: MediaWatchState) async {
        // This method should be called from SwiftUI views using onChange modifiers
        // For now, provide helper methods that can be called when state changes
    }
    
    /// Call this when watch progress changes (from SwiftUI onChange)
    func checkCompletion(watchState: MediaWatchState) async {
        if watchState.watchProgress > 0.8 && watchState.watchProgress != lastWatchProgress {
            if let productionId = watchState.currentProduction?.id {
                await handleCompletion(
                    productionId: productionId,
                    tasteProfile: getTasteProfile()
                )
            }
            lastWatchProgress = watchState.watchProgress
        }
    }
    
    /// Call this when skipped productions change (from SwiftUI onChange)
    func checkSkipStreak(watchState: MediaWatchState) async {
        if watchState.skippedProductions.count >= 3 && 
           watchState.skippedProductions.count != lastSkippedCount {
            let count = watchState.skippedProductions.count
            let tasteProfile = getTasteProfile()
            await handleSkipStreak(count: count, tasteProfile: tasteProfile)
            lastSkippedCount = count
        }
    }
    
    /// Call this when view counts change (from SwiftUI onChange)
    func checkRepeatViewing(watchState: MediaWatchState) async {
        for (productionId, viewCount) in watchState.viewCounts where viewCount >= 2 {
            let tasteProfile = getTasteProfile()
            await handleRepeatView(productionId: productionId, viewCount: viewCount, tasteProfile: tasteProfile)
        }
    }
    
    /// Call this when pause moments change (from SwiftUI onChange)
    func checkPausePatterns(watchState: MediaWatchState) {
        if watchState.pauseMoments.count > lastPauseCount {
            analyzePausePatterns(pauseMoments: watchState.pauseMoments)
            lastPauseCount = watchState.pauseMoments.count
        }
    }
    
    private func getTasteProfile() -> TasteProfile {
        // In production, fetch from SwiftData
        // For now, return a default profile
        return TasteProfile()
    }
    
    private func analyzePausePatterns(pauseMoments: [TimeInterval]) {
        // Analyze pause timing to identify emotional beats
        // Group pauses by time intervals to find emotional moments
        let groupedPauses = Dictionary(grouping: pauseMoments) { moment in
            Int(moment / 10) * 10 // Group by 10-second intervals
        }
        
        // Find intervals with multiple pauses (emotional moments)
        for (interval, pauses) in groupedPauses where pauses.count >= 2 {
            // This indicates an emotional beat at this time interval
            // Store for future story generation
        }
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


//
//  MediaWatchState.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import Observation

@Observable
final class MediaWatchState {
    var currentProduction: Production?
    var watchProgress: Double = 0.0 // 0.0 to 1.0
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0.0
    var completedProductions: [UUID] = []
    var skippedProductions: [UUID] = []
    var likedProductions: [UUID] = []
    var pauseMoments: [TimeInterval] = [] // Track when user pauses (for emotional beat analysis)
    var viewCounts: [UUID: Int] = [:] // Track how many times each production is viewed
    
    func markCompleted(_ productionId: UUID) {
        if !completedProductions.contains(productionId) {
            completedProductions.append(productionId)
        }
        watchProgress = 1.0
        isPlaying = false
    }
    
    func markSkipped(_ productionId: UUID) {
        if !skippedProductions.contains(productionId) {
            skippedProductions.append(productionId)
        }
        reset()
    }
    
    func markLiked(_ productionId: UUID) {
        if !likedProductions.contains(productionId) {
            likedProductions.append(productionId)
        }
    }
    
    func recordPause(at time: TimeInterval) {
        pauseMoments.append(time)
    }
    
    func incrementViewCount(for productionId: UUID) {
        viewCounts[productionId, default: 0] += 1
    }
    
    func reset() {
        currentProduction = nil
        watchProgress = 0.0
        isPlaying = false
        currentTime = 0.0
        pauseMoments = []
    }
}


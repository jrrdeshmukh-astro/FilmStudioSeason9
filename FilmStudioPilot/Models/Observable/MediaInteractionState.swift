//
//  MediaInteractionState.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import Observation

@Observable
final class MediaInteractionState {
    var recentInteractions: [MediaInteraction] = []
    var skipStreak: Int = 0 // Track consecutive skips
    var likeStreak: Int = 0 // Track consecutive likes
    var averageWatchTime: TimeInterval = 0.0
    var totalWatchTime: TimeInterval = 0.0
    
    func recordInteraction(_ interaction: MediaInteraction) {
        recentInteractions.append(interaction)
        
        // Keep only last 50 interactions
        if recentInteractions.count > 50 {
            recentInteractions.removeFirst()
        }
        
        switch interaction.type {
        case .skip:
            skipStreak += 1
            likeStreak = 0
        case .like:
            likeStreak += 1
            skipStreak = 0
        case .complete:
            skipStreak = 0
            likeStreak = 0
        case .pause:
            break
        }
    }
    
    func updateWatchTime(_ duration: TimeInterval) {
        totalWatchTime += duration
        let interactionCount = recentInteractions.filter { $0.type == .complete }.count
        if interactionCount > 0 {
            averageWatchTime = totalWatchTime / Double(interactionCount)
        }
    }
}

struct MediaInteraction: Identifiable, Codable {
    let id: UUID
    let productionId: UUID
    let type: InteractionType
    let timestamp: Date
    let context: InteractionContext?
    
    init(
        id: UUID = UUID(),
        productionId: UUID,
        type: InteractionType,
        timestamp: Date = Date(),
        context: InteractionContext? = nil
    ) {
        self.id = id
        self.productionId = productionId
        self.type = type
        self.timestamp = timestamp
        self.context = context
    }
}

enum InteractionType: String, Codable {
    case like = "like"
    case skip = "skip"
    case complete = "complete"
    case pause = "pause"
}

struct InteractionContext: Codable {
    let pauseTime: TimeInterval?
    let watchProgress: Double?
    let duration: TimeInterval?
}


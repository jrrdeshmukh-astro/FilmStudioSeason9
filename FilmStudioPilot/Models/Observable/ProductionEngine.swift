//
//  ProductionEngine.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import Observation

@Observable
final class ProductionEngine {
    var isRunning: Bool = false
    var currentStage: ProductionStage?
    var processingQueue: [Production] = []
    
    func start() {
        isRunning = true
    }
    
    func stop() {
        isRunning = false
    }
    
    func processProduction(_ production: Production) {
        processingQueue.append(production)
    }
}

enum ProductionStage: String, Codable {
    case story = "story"
    case script = "script"
    case storyboard = "storyboard"
    case animatic = "animatic"
    case final = "final"
}


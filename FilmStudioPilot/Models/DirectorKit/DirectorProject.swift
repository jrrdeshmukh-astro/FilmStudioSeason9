//
//  DirectorProject.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class DirectorProject {
    var id: UUID
    var title: String
    var screenplay: Screenplay?
    var scenes: [DirectedScene]
    var assets: AssetCatalog?
    var createdAt: Date
    var updatedAt: Date
    var status: ProjectStatus
    
    init(
        id: UUID = UUID(),
        title: String,
        screenplay: Screenplay? = nil,
        scenes: [DirectedScene] = [],
        assets: AssetCatalog? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        status: ProjectStatus = .draft
    ) {
        self.id = id
        self.title = title
        self.screenplay = screenplay
        self.scenes = scenes
        self.assets = assets
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
    }
}

enum ProjectStatus: String, Codable {
    case draft = "draft"
    case inProduction = "in_production"
    case postProduction = "post_production"
    case completed = "completed"
}


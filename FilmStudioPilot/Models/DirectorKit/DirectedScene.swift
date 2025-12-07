//
//  DirectedScene.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class DirectedScene {
    var id: UUID
    var sceneNumber: Int
    var screenplayScene: ScreenplayScene?
    var shots: [Shot]
    var blocking: BlockingPlan?
    var timing: SceneTiming
    var status: SceneStatus
    
    init(
        id: UUID = UUID(),
        sceneNumber: Int,
        screenplayScene: ScreenplayScene? = nil,
        shots: [Shot] = [],
        blocking: BlockingPlan? = nil,
        timing: SceneTiming = SceneTiming(),
        status: SceneStatus = .planned
    ) {
        self.id = id
        self.sceneNumber = sceneNumber
        self.screenplayScene = screenplayScene
        self.shots = shots
        self.blocking = blocking
        self.timing = timing
        self.status = status
    }
}

struct Shot: Codable, Identifiable {
    let id: UUID
    var shotNumber: Int
    var cameraSetup: CameraSetup
    var framing: Framing
    var dialogue: [DialogueBlock]? // Dialogue in this shot
    var action: [ActionLine]? // Action in this shot
    var timing: ShotTiming
    var visualNotes: String?
    
    init(
        id: UUID = UUID(),
        shotNumber: Int,
        cameraSetup: CameraSetup,
        framing: Framing,
        dialogue: [DialogueBlock]? = nil,
        action: [ActionLine]? = nil,
        timing: ShotTiming = ShotTiming(),
        visualNotes: String? = nil
    ) {
        self.id = id
        self.shotNumber = shotNumber
        self.cameraSetup = cameraSetup
        self.framing = framing
        self.dialogue = dialogue
        self.action = action
        self.timing = timing
        self.visualNotes = visualNotes
    }
}

struct CameraSetup: Codable {
    var position: SIMD3<Float>
    var rotation: SIMD3<Float>
    var focalLength: Float // in mm
    var aperture: Float // f-stop
    var cameraType: CameraType
    
    enum CameraType: String, Codable {
        case wide = "wide"
        case medium = "medium"
        case closeUp = "close_up"
        case extremeCloseUp = "extreme_close_up"
        case establishing = "establishing"
        case overShoulder = "over_shoulder"
        case pointOfView = "point_of_view"
    }
}

struct Framing: Codable {
    var composition: Composition
    var ruleOfThirds: Bool
    var depthOfField: DepthOfField
    
    enum Composition: String, Codable {
        case centered = "centered"
        case ruleOfThirds = "rule_of_thirds"
        case leadingLines = "leading_lines"
        case symmetry = "symmetry"
        case framing = "framing"
    }
    
    enum DepthOfField: String, Codable {
        case shallow = "shallow"
        case medium = "medium"
        case deep = "deep"
    }
}

struct BlockingPlan: Codable {
    var characterPositions: [CharacterPosition]
    var movementPaths: [MovementPath]
    var interactionPoints: [InteractionPoint]
    
    struct CharacterPosition: Codable, Identifiable {
        let id: UUID
        var characterName: String
        var position: SIMD3<Float>
        var rotation: SIMD3<Float>
        var timing: TimeInterval // When character is at this position
        
        init(
            id: UUID = UUID(),
            characterName: String,
            position: SIMD3<Float>,
            rotation: SIMD3<Float> = [0, 0, 0],
            timing: TimeInterval = 0
        ) {
            self.id = id
            self.characterName = characterName
            self.position = position
            self.rotation = rotation
            self.timing = timing
        }
    }
    
    struct MovementPath: Codable, Identifiable {
        let id: UUID
        var characterName: String
        var waypoints: [SIMD3<Float>]
        var duration: TimeInterval
        
        init(
            id: UUID = UUID(),
            characterName: String,
            waypoints: [SIMD3<Float>] = [],
            duration: TimeInterval = 0
        ) {
            self.id = id
            self.characterName = characterName
            self.waypoints = waypoints
            self.duration = duration
        }
    }
    
    struct InteractionPoint: Codable, Identifiable {
        let id: UUID
        var characters: [String] // Characters involved
        var position: SIMD3<Float>
        var interactionType: InteractionType
        var timing: TimeInterval
        
        init(
            id: UUID = UUID(),
            characters: [String],
            position: SIMD3<Float>,
            interactionType: InteractionType,
            timing: TimeInterval = 0
        ) {
            self.id = id
            self.characters = characters
            self.position = position
            self.interactionType = interactionType
            self.timing = timing
        }
    }
    
    enum InteractionType: String, Codable {
        case dialogue = "dialogue"
        case physical = "physical"
        case eyeContact = "eye_contact"
        case proximity = "proximity"
    }
}

struct SceneTiming: Codable {
    var estimatedDuration: TimeInterval
    var startTime: TimeInterval
    var endTime: TimeInterval
    
    init(
        estimatedDuration: TimeInterval = 0,
        startTime: TimeInterval = 0,
        endTime: TimeInterval = 0
    ) {
        self.estimatedDuration = estimatedDuration
        self.startTime = startTime
        self.endTime = endTime
    }
}

struct ShotTiming: Codable {
    var duration: TimeInterval
    var startTime: TimeInterval
    var endTime: TimeInterval
    
    init(
        duration: TimeInterval = 0,
        startTime: TimeInterval = 0,
        endTime: TimeInterval = 0
    ) {
        self.duration = duration
        self.startTime = startTime
        self.endTime = endTime
    }
}

enum SceneStatus: String, Codable {
    case planned = "planned"
    case storyboarded = "storyboarded"
    case blocked = "blocked"
    case shot = "shot"
    case edited = "edited"
    case completed = "completed"
}


//
//  Screenplay.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class Screenplay {
    var id: UUID
    var title: String
    var osfXML: String? // Open Screenplay Format XML
    var scenes: [ScreenplayScene]
    var characters: [Character]
    var metadata: ScreenplayMetadata?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        osfXML: String? = nil,
        scenes: [ScreenplayScene] = [],
        characters: [Character] = [],
        metadata: ScreenplayMetadata? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.osfXML = osfXML
        self.scenes = scenes
        self.characters = characters
        self.metadata = metadata
        self.createdAt = createdAt
    }
}

struct ScreenplayScene: Codable, Identifiable {
    let id: UUID
    var sceneNumber: Int
    var heading: SceneHeading
    var action: [ActionLine]
    var dialogue: [DialogueBlock]
    var transitions: [Transition]
    
    init(
        id: UUID = UUID(),
        sceneNumber: Int,
        heading: SceneHeading,
        action: [ActionLine] = [],
        dialogue: [DialogueBlock] = [],
        transitions: [Transition] = []
    ) {
        self.id = id
        self.sceneNumber = sceneNumber
        self.heading = heading
        self.action = action
        self.dialogue = dialogue
        self.transitions = transitions
    }
}

struct SceneHeading: Codable {
    var location: String
    var timeOfDay: String // "DAY", "NIGHT", "DAWN", "DUSK"
    var interiorExterior: InteriorExterior
    
    enum InteriorExterior: String, Codable {
        case interior = "INT"
        case exterior = "EXT"
    }
}

struct ActionLine: Codable {
    var text: String
    var timing: TimeInterval? // Estimated duration
}

struct DialogueBlock: Codable, Identifiable {
    let id: UUID
    var character: String
    var dialogue: String
    var parenthetical: String? // (emotionally) or (whispering)
    var timing: TimeInterval? // Estimated speaking duration
    
    init(
        id: UUID = UUID(),
        character: String,
        dialogue: String,
        parenthetical: String? = nil,
        timing: TimeInterval? = nil
    ) {
        self.id = id
        self.character = character
        self.dialogue = dialogue
        self.parenthetical = parenthetical
        self.timing = timing
    }
}

struct Transition: Codable {
    var type: TransitionType
    var targetSceneNumber: Int?
    
    enum TransitionType: String, Codable {
        case cut = "CUT TO"
        case fadeIn = "FADE IN"
        case fadeOut = "FADE OUT"
        case dissolve = "DISSOLVE TO"
        case matchCut = "MATCH CUT"
    }
}

struct Character: Codable, Identifiable {
    let id: UUID
    var name: String
    var description: String?
    var role: CharacterRole
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        role: CharacterRole = .supporting
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.role = role
    }
}

enum CharacterRole: String, Codable {
    case protagonist = "protagonist"
    case antagonist = "antagonist"
    case supporting = "supporting"
    case minor = "minor"
}

struct ScreenplayMetadata: Codable {
    var author: String?
    var version: String?
    var date: Date?
    var notes: String?
}


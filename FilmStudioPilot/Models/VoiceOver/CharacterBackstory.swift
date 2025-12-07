//
//  CharacterBackstory.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class CharacterBackstory {
    var id: UUID
    var characterName: String
    var role: CharacterRole
    var biography: String
    var background: CharacterBackground
    var personalityTraits: [PersonalityTrait]
    var emotionalRange: EmotionalRange
    var voiceProfile: VoiceProfile?
    var relationships: [CharacterRelationship]
    var objectives: [CharacterObjective] // Stanislavski objectives
    var superobjective: String? // Overall character goal
    var givenCircumstances: [String] // Stanislavski "given circumstances"
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        characterName: String,
        role: CharacterRole,
        biography: String = "",
        background: CharacterBackground = CharacterBackground(),
        personalityTraits: [PersonalityTrait] = [],
        emotionalRange: EmotionalRange = EmotionalRange(),
        voiceProfile: VoiceProfile? = nil,
        relationships: [CharacterRelationship] = [],
        objectives: [CharacterObjective] = [],
        superobjective: String? = nil,
        givenCircumstances: [String] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.characterName = characterName
        self.role = role
        self.biography = biography
        self.background = background
        self.personalityTraits = personalityTraits
        self.emotionalRange = emotionalRange
        self.voiceProfile = voiceProfile
        self.relationships = relationships
        self.objectives = objectives
        self.superobjective = superobjective
        self.givenCircumstances = givenCircumstances
        self.createdAt = createdAt
    }
}

struct CharacterBackground: Codable {
    var age: Int?
    var occupation: String?
    var education: String?
    var socioeconomicStatus: SocioeconomicStatus
    var culturalBackground: String?
    var hometown: String?
    var significantEvents: [SignificantEvent]
    
    init(
        age: Int? = nil,
        occupation: String? = nil,
        education: String? = nil,
        socioeconomicStatus: SocioeconomicStatus = .middle,
        culturalBackground: String? = nil,
        hometown: String? = nil,
        significantEvents: [SignificantEvent] = []
    ) {
        self.age = age
        self.occupation = occupation
        self.education = education
        self.socioeconomicStatus = socioeconomicStatus
        self.culturalBackground = culturalBackground
        self.hometown = hometown
        self.significantEvents = significantEvents
    }
}

enum SocioeconomicStatus: String, Codable {
    case lower = "lower"
    case middle = "middle"
    case upper = "upper"
    case upperMiddle = "upper_middle"
}

struct SignificantEvent: Codable, Identifiable {
    let id: UUID
    var description: String
    var age: Int?
    var impact: EventImpact
    
    init(
        id: UUID = UUID(),
        description: String,
        age: Int? = nil,
        impact: EventImpact = .moderate
    ) {
        self.id = id
        self.description = description
        self.age = age
        self.impact = impact
    }
}

enum EventImpact: String, Codable {
    case low = "low"
    case moderate = "moderate"
    case high = "high"
    case traumatic = "traumatic"
}

struct PersonalityTrait: Codable, Identifiable {
    let id: UUID
    var trait: String
    var intensity: Float // 0.0 to 1.0
    var context: String? // When this trait is most evident
    
    init(
        id: UUID = UUID(),
        trait: String,
        intensity: Float = 0.5,
        context: String? = nil
    ) {
        self.id = id
        self.trait = trait
        self.intensity = intensity
        self.context = context
    }
}

struct EmotionalRange: Codable {
    var primaryEmotions: [Emotion]
    var emotionalDepth: EmotionalDepth
    var emotionalTriggers: [EmotionalTrigger]
    
    init(
        primaryEmotions: [Emotion] = [],
        emotionalDepth: EmotionalDepth = .moderate,
        emotionalTriggers: [EmotionalTrigger] = []
    ) {
        self.primaryEmotions = primaryEmotions
        self.emotionalDepth = emotionalDepth
        self.emotionalTriggers = emotionalTriggers
    }
}

enum Emotion: String, Codable {
    case joy = "joy"
    case sadness = "sadness"
    case anger = "anger"
    case fear = "fear"
    case surprise = "surprise"
    case disgust = "disgust"
    case contempt = "contempt"
    case love = "love"
    case shame = "shame"
    case guilt = "guilt"
}

enum EmotionalDepth: String, Codable {
    case shallow = "shallow"
    case moderate = "moderate"
    case deep = "deep"
    case profound = "profound"
}

struct EmotionalTrigger: Codable, Identifiable {
    let id: UUID
    var trigger: String
    var emotion: Emotion
    var intensity: Float
    
    init(
        id: UUID = UUID(),
        trigger: String,
        emotion: Emotion,
        intensity: Float = 0.5
    ) {
        self.id = id
        self.trigger = trigger
        self.emotion = emotion
        self.intensity = intensity
    }
}

struct CharacterRelationship: Codable, Identifiable {
    let id: UUID
    var otherCharacter: String
    var relationshipType: RelationshipType
    var history: String?
    var emotionalConnection: Float // 0.0 to 1.0
    var currentStatus: RelationshipStatus
    
    init(
        id: UUID = UUID(),
        otherCharacter: String,
        relationshipType: RelationshipType,
        history: String? = nil,
        emotionalConnection: Float = 0.5,
        currentStatus: RelationshipStatus = .neutral
    ) {
        self.id = id
        self.otherCharacter = otherCharacter
        self.relationshipType = relationshipType
        self.history = history
        self.emotionalConnection = emotionalConnection
        self.currentStatus = currentStatus
    }
}

enum RelationshipType: String, Codable {
    case family = "family"
    case friend = "friend"
    case romantic = "romantic"
    case professional = "professional"
    case enemy = "enemy"
    case acquaintance = "acquaintance"
}

enum RelationshipStatus: String, Codable {
    case positive = "positive"
    case neutral = "neutral"
    case negative = "negative"
    case conflicted = "conflicted"
}

struct CharacterObjective: Codable, Identifiable {
    let id: UUID
    var objective: String // What the character wants
    var obstacle: String? // What stands in the way
    var tactics: [String] // How they'll achieve it
    var sceneNumber: Int? // Which scene this applies to
    var urgency: Urgency
    
    init(
        id: UUID = UUID(),
        objective: String,
        obstacle: String? = nil,
        tactics: [String] = [],
        sceneNumber: Int? = nil,
        urgency: Urgency = .moderate
    ) {
        self.id = id
        self.objective = objective
        self.obstacle = obstacle
        self.tactics = tactics
        self.sceneNumber = sceneNumber
        self.urgency = urgency
    }
}

enum Urgency: String, Codable {
    case low = "low"
    case moderate = "moderate"
    case high = "high"
    case critical = "critical"
}


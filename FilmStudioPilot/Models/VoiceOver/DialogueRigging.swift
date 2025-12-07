//
//  DialogueRigging.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import AVFoundation

struct DialogueRigging: Codable, Identifiable {
    let id: UUID
    var dialogueBlock: DialogueBlock
    var characterBackstoryID: UUID? // Store ID instead of full object (CharacterBackstory is SwiftData @Model)
    var voiceProfile: VoiceProfile
    var timing: DialogueTiming
    var emotionalContext: EmotionalContext
    var deliveryInstructions: DeliveryInstructions
    var audioAsset: AudioAsset?
    
    // Non-Codable property for runtime use
    var characterBackstory: CharacterBackstory? {
        get { nil } // Will be resolved from SwiftData using characterBackstoryID
        set { characterBackstoryID = newValue?.id }
    }
    
    init(
        id: UUID = UUID(),
        dialogueBlock: DialogueBlock,
        characterBackstory: CharacterBackstory? = nil,
        voiceProfile: VoiceProfile,
        timing: DialogueTiming = DialogueTiming(),
        emotionalContext: EmotionalContext = EmotionalContext(),
        deliveryInstructions: DeliveryInstructions = DeliveryInstructions(),
        audioAsset: AudioAsset? = nil
    ) {
        self.id = id
        self.dialogueBlock = dialogueBlock
        self.characterBackstoryID = characterBackstory?.id
        self.voiceProfile = voiceProfile
        self.timing = timing
        self.emotionalContext = emotionalContext
        self.deliveryInstructions = deliveryInstructions
        self.audioAsset = audioAsset
    }
}

struct DialogueTiming: Codable {
    var startTime: TimeInterval
    var duration: TimeInterval
    var pauses: [Pause]
    var emphasisPoints: [EmphasisPoint]
    var pacing: Pacing
    
    init(
        startTime: TimeInterval = 0,
        duration: TimeInterval = 0,
        pauses: [Pause] = [],
        emphasisPoints: [EmphasisPoint] = [],
        pacing: Pacing = .normal
    ) {
        self.startTime = startTime
        self.duration = duration
        self.pauses = pauses
        self.emphasisPoints = emphasisPoints
        self.pacing = pacing
    }
}

struct Pause: Codable, Identifiable {
    let id: UUID
    var position: TimeInterval // Position within dialogue
    var duration: TimeInterval
    var type: PauseType
    var purpose: PausePurpose
    
    init(
        id: UUID = UUID(),
        position: TimeInterval,
        duration: TimeInterval,
        type: PauseType = .natural,
        purpose: PausePurpose = .breath
    ) {
        self.id = id
        self.position = position
        self.duration = duration
        self.type = type
        self.purpose = purpose
    }
}

enum PauseType: String, Codable {
    case natural = "natural"
    case dramatic = "dramatic"
    case emotional = "emotional"
    case comedic = "comedic"
    case suspenseful = "suspenseful"
}

enum PausePurpose: String, Codable {
    case breath = "breath"
    case emphasis = "emphasis"
    case reaction = "reaction"
    case transition = "transition"
    case subtext = "subtext"
}

struct EmphasisPoint: Codable, Identifiable {
    let id: UUID
    var position: TimeInterval
    var word: String
    var intensity: Float // 0.0 to 1.0
    var technique: EmphasisTechnique
    
    init(
        id: UUID = UUID(),
        position: TimeInterval,
        word: String,
        intensity: Float = 0.5,
        technique: EmphasisTechnique = .volume
    ) {
        self.id = id
        self.position = position
        self.word = word
        self.intensity = intensity
        self.technique = technique
    }
}

enum EmphasisTechnique: String, Codable {
    case volume = "volume"
    case pitch = "pitch"
    case pace = "pace"
    case pause = "pause"
    case combination = "combination"
}

enum Pacing: String, Codable {
    case slow = "slow"
    case normal = "normal"
    case fast = "fast"
    case varied = "varied"
}

struct EmotionalContext: Codable {
    var primaryEmotion: Emotion
    var emotionalIntensity: Float // 0.0 to 1.0
    var subtext: String?
    var relationshipContext: RelationshipContext?
    var sceneObjective: String? // Character's objective in this scene
    
    init(
        primaryEmotion: Emotion = .neutral,
        emotionalIntensity: Float = 0.5,
        subtext: String? = nil,
        relationshipContext: RelationshipContext? = nil,
        sceneObjective: String? = nil
    ) {
        self.primaryEmotion = primaryEmotion
        self.emotionalIntensity = emotionalIntensity
        self.subtext = subtext
        self.relationshipContext = relationshipContext
        self.sceneObjective = sceneObjective
    }
}

// Emotion enum is defined in CharacterBackstory.swift

struct RelationshipContext: Codable {
    var otherCharacter: String
    var relationshipType: RelationshipType
    var currentStatus: RelationshipStatus
    var history: String?
    
    init(
        otherCharacter: String,
        relationshipType: RelationshipType,
        currentStatus: RelationshipStatus = .neutral,
        history: String? = nil
    ) {
        self.otherCharacter = otherCharacter
        self.relationshipType = relationshipType
        self.currentStatus = currentStatus
        self.history = history
    }
}

struct DeliveryInstructions: Codable {
    var technique: ActingTechnique
    var focus: DeliveryFocus
    var notes: String?
    var beats: [Beat]
    
    init(
        technique: ActingTechnique = .stanislavski,
        focus: DeliveryFocus = .objective,
        notes: String? = nil,
        beats: [Beat] = []
    ) {
        self.technique = technique
        self.focus = focus
        self.notes = notes
        self.beats = beats
    }
}

enum ActingTechnique: String, Codable {
    case stanislavski = "stanislavski"
    case meisner = "meisner"
    case method = "method"
    case classical = "classical"
    case natural = "natural"
}

enum DeliveryFocus: String, Codable {
    case objective = "objective"
    case obstacle = "obstacle"
    case partner = "partner"
    case emotionalMemory = "emotional_memory"
    case givenCircumstances = "given_circumstances"
}

struct Beat: Codable, Identifiable {
    let id: UUID
    var startTime: TimeInterval
    var duration: TimeInterval
    var objective: String
    var tactic: String
    var emotionalShift: Emotion?
    
    init(
        id: UUID = UUID(),
        startTime: TimeInterval,
        duration: TimeInterval,
        objective: String,
        tactic: String,
        emotionalShift: Emotion? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.objective = objective
        self.tactic = tactic
        self.emotionalShift = emotionalShift
    }
}


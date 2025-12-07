//
//  VoiceProfile.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import AVFoundation

struct VoiceProfile: Codable {
    var pitch: Float // 0.0 to 1.0 (low to high)
    var pace: Float // 0.0 to 1.0 (slow to fast)
    var volume: Float // 0.0 to 1.0 (quiet to loud)
    var timbre: Timbre
    var accent: Accent?
    var vocalCharacteristics: [VocalCharacteristic]
    var emotionalDelivery: [EmotionalDelivery]
    
    init(
        pitch: Float = 0.5,
        pace: Float = 0.5,
        volume: Float = 0.7,
        timbre: Timbre = .neutral,
        accent: Accent? = nil,
        vocalCharacteristics: [VocalCharacteristic] = [],
        emotionalDelivery: [EmotionalDelivery] = []
    ) {
        self.pitch = pitch
        self.pace = pace
        self.volume = volume
        self.timbre = timbre
        self.accent = accent
        self.vocalCharacteristics = vocalCharacteristics
        self.emotionalDelivery = emotionalDelivery
    }
}

enum Timbre: String, Codable {
    case warm = "warm"
    case bright = "bright"
    case dark = "dark"
    case nasal = "nasal"
    case breathy = "breathy"
    case resonant = "resonant"
    case neutral = "neutral"
}

struct Accent: Codable {
    var type: AccentType
    var strength: Float // 0.0 to 1.0
    
    init(type: AccentType, strength: Float = 0.5) {
        self.type = type
        self.strength = strength
    }
}

enum AccentType: String, Codable {
    case american = "american"
    case british = "british"
    case australian = "australian"
    case irish = "irish"
    case scottish = "scottish"
    case southern = "southern"
    case newYork = "new_york"
    case none = "none"
}

struct VocalCharacteristic: Codable, Identifiable {
    let id: UUID
    var characteristic: String
    var intensity: Float
    
    init(
        id: UUID = UUID(),
        characteristic: String,
        intensity: Float = 0.5
    ) {
        self.id = id
        self.characteristic = characteristic
        self.intensity = intensity
    }
}

struct EmotionalDelivery: Codable {
    var emotion: Emotion
    var pitchModification: Float // -1.0 to 1.0 (lower to higher)
    var paceModification: Float // -1.0 to 1.0 (slower to faster)
    var volumeModification: Float // -1.0 to 1.0 (quieter to louder)
    var vocalQuality: VocalQuality
    
    init(
        emotion: Emotion,
        pitchModification: Float = 0.0,
        paceModification: Float = 0.0,
        volumeModification: Float = 0.0,
        vocalQuality: VocalQuality = .normal
    ) {
        self.emotion = emotion
        self.pitchModification = pitchModification
        self.paceModification = paceModification
        self.volumeModification = volumeModification
        self.vocalQuality = vocalQuality
    }
}

enum VocalQuality: String, Codable {
    case normal = "normal"
    case whisper = "whisper"
    case shout = "shout"
    case strained = "strained"
    case breathy = "breathy"
    case crisp = "crisp"
    case soft = "soft"
}


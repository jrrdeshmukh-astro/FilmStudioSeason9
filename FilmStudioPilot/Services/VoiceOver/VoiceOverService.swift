//
//  VoiceOverService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import AVFoundation
import Combine

@MainActor
class VoiceOverService: ObservableObject {
    @Published var isGenerating: Bool = false
    
    /// Generate dialogue rigging for a dialogue block based on character backstory
    func rigDialogue(
        _ dialogue: DialogueBlock,
        characterBackstory: CharacterBackstory,
        sceneContext: ScreenplayScene? = nil
    ) -> DialogueRigging {
        // Get voice profile from character backstory
        let voiceProfile = characterBackstory.voiceProfile ?? generateVoiceProfile(from: characterBackstory)
        
        // Determine emotional context
        let emotionalContext = determineEmotionalContext(
            dialogue: dialogue,
            characterBackstory: characterBackstory,
            sceneContext: sceneContext
        )
        
        // Calculate timing based on dialogue length and character pace
        let timing = calculateDialogueTiming(
            dialogue: dialogue,
            voiceProfile: voiceProfile,
            emotionalContext: emotionalContext
        )
        
        // Generate delivery instructions based on acting technique
        let deliveryInstructions = generateDeliveryInstructions(
            dialogue: dialogue,
            characterBackstory: characterBackstory,
            emotionalContext: emotionalContext
        )
        
        return DialogueRigging(
            dialogueBlock: dialogue,
            characterBackstory: characterBackstory,
            voiceProfile: voiceProfile,
            timing: timing,
            emotionalContext: emotionalContext,
            deliveryInstructions: deliveryInstructions
        )
    }
    
    /// Generate voice profile from character backstory
    private func generateVoiceProfile(from backstory: CharacterBackstory) -> VoiceProfile {
        // Determine pitch based on character traits
        var pitch: Float = 0.5
        if backstory.personalityTraits.contains(where: { $0.trait.lowercased().contains("confident") }) {
            pitch = 0.6
        } else if backstory.personalityTraits.contains(where: { $0.trait.lowercased().contains("shy") }) {
            pitch = 0.4
        }
        
        // Determine pace based on personality
        var pace: Float = 0.5
        if backstory.personalityTraits.contains(where: { $0.trait.lowercased().contains("energetic") }) {
            pace = 0.7
        } else if backstory.personalityTraits.contains(where: { $0.trait.lowercased().contains("thoughtful") }) {
            pace = 0.3
        }
        
        // Determine timbre based on background
        var timbre: Timbre = .neutral
        if let occupation = backstory.background.occupation {
            if occupation.lowercased().contains("teacher") || occupation.lowercased().contains("professor") {
                timbre = .resonant
            } else if occupation.lowercased().contains("artist") {
                timbre = .warm
            }
        }
        
        // Determine accent from cultural background
        var accent: Accent? = nil
        if let cultural = backstory.background.culturalBackground {
            if cultural.lowercased().contains("british") {
                accent = Accent(type: .british, strength: 0.6)
            } else if cultural.lowercased().contains("southern") {
                accent = Accent(type: .southern, strength: 0.5)
            }
        }
        
        return VoiceProfile(
            pitch: pitch,
            pace: pace,
            volume: 0.7,
            timbre: timbre,
            accent: accent
        )
    }
    
    /// Determine emotional context for dialogue
    private func determineEmotionalContext(
        dialogue: DialogueBlock,
        characterBackstory: CharacterBackstory,
        sceneContext: ScreenplayScene?
    ) -> EmotionalContext {
        // Check parenthetical for emotion
        var primaryEmotion: Emotion = .neutral
        if let parenthetical = dialogue.parenthetical?.lowercased() {
            if parenthetical.contains("angry") || parenthetical.contains("furious") {
                primaryEmotion = .anger
            } else if parenthetical.contains("sad") || parenthetical.contains("upset") {
                primaryEmotion = .sadness
            } else if parenthetical.contains("happy") || parenthetical.contains("joyful") {
                primaryEmotion = .joy
            } else if parenthetical.contains("fear") || parenthetical.contains("afraid") {
                primaryEmotion = .fear
            }
        }
        
        // Find relationship context if dialogue mentions another character
        var relationshipContext: RelationshipContext? = nil
        if let scene = sceneContext {
            for otherDialogue in scene.dialogue {
                if otherDialogue.character != dialogue.character {
                    if let relationship = characterBackstory.relationships.first(where: { $0.otherCharacter == otherDialogue.character }) {
                        relationshipContext = RelationshipContext(
                            otherCharacter: relationship.otherCharacter,
                            relationshipType: relationship.relationshipType,
                            currentStatus: relationship.currentStatus,
                            history: relationship.history
                        )
                        break
                    }
                }
            }
        }
        
        // Get scene objective
        let sceneObjective = characterBackstory.objectives.first(where: { $0.sceneNumber == sceneContext?.sceneNumber })?.objective
        
        return EmotionalContext(
            primaryEmotion: primaryEmotion,
            emotionalIntensity: 0.5,
            subtext: extractSubtext(from: dialogue.dialogue),
            relationshipContext: relationshipContext,
            sceneObjective: sceneObjective
        )
    }
    
    /// Calculate dialogue timing
    private func calculateDialogueTiming(
        dialogue: DialogueBlock,
        voiceProfile: VoiceProfile,
        emotionalContext: EmotionalContext
    ) -> DialogueTiming {
        // Base duration: average speaking rate is 150 words per minute
        let wordCount = dialogue.dialogue.split(separator: " ").count
        var baseDuration = TimeInterval(wordCount) / 2.5 // words per second
        
        // Adjust for pace
        if voiceProfile.pace < 0.4 {
            baseDuration *= 1.3 // Slower
        } else if voiceProfile.pace > 0.6 {
            baseDuration *= 0.8 // Faster
        }
        
        // Adjust for emotion
        if emotionalContext.primaryEmotion == .anger || emotionalContext.primaryEmotion == .fear {
            baseDuration *= 0.9 // Faster when emotional
        } else if emotionalContext.primaryEmotion == .sadness {
            baseDuration *= 1.2 // Slower when sad
        }
        
        // Generate pauses
        let pauses = generatePauses(
            dialogue: dialogue,
            emotionalContext: emotionalContext
        )
        
        // Generate emphasis points
        let emphasisPoints = generateEmphasisPoints(
            dialogue: dialogue,
            emotionalContext: emotionalContext
        )
        
        // Determine pacing
        let pacing: Pacing = voiceProfile.pace < 0.4 ? .slow : (voiceProfile.pace > 0.6 ? .fast : .normal)
        
        return DialogueTiming(
            startTime: 0,
            duration: baseDuration,
            pauses: pauses,
            emphasisPoints: emphasisPoints,
            pacing: pacing
        )
    }
    
    /// Generate pauses in dialogue
    private func generatePauses(
        dialogue: DialogueBlock,
        emotionalContext: EmotionalContext
    ) -> [Pause] {
        var pauses: [Pause] = []
        let words = dialogue.dialogue.split(separator: " ")
        
        // Natural pauses at commas and periods
        var currentTime: TimeInterval = 0
        for (index, word) in words.enumerated() {
            if word.hasSuffix(",") || word.hasSuffix(".") {
                let pauseDuration: TimeInterval = word.hasSuffix(".") ? 0.5 : 0.3
                pauses.append(Pause(
                    position: currentTime,
                    duration: pauseDuration,
                    type: .natural,
                    purpose: .breath
                ))
            }
            currentTime += 0.4 // Average word duration
        }
        
        // Dramatic pause for emotional moments
        if emotionalContext.primaryEmotion == .sadness || emotionalContext.primaryEmotion == .anger {
            let midPoint = TimeInterval(words.count) * 0.4 / 2.5
            pauses.append(Pause(
                position: midPoint,
                duration: 0.8,
                type: .dramatic,
                purpose: .emphasis
            ))
        }
        
        return pauses
    }
    
    /// Generate emphasis points
    private func generateEmphasisPoints(
        dialogue: DialogueBlock,
        emotionalContext: EmotionalContext
    ) -> [EmphasisPoint] {
        var emphasisPoints: [EmphasisPoint] = []
        let words = dialogue.dialogue.split(separator: " ")
        
        // Emphasize key words (capitalized, emotional words)
        var currentTime: TimeInterval = 0
        for word in words {
            let wordStr = String(word).trimmingCharacters(in: .punctuationCharacters)
            
            // Check if word should be emphasized
            if wordStr.first?.isUppercase == true && wordStr.count > 3 {
                emphasisPoints.append(EmphasisPoint(
                    position: currentTime,
                    word: wordStr,
                    intensity: 0.7,
                    technique: .volume
                ))
            }
            
            // Emphasize emotional words
            let emotionalWords = ["never", "always", "must", "can't", "won't", "love", "hate", "fear"]
            if emotionalWords.contains(wordStr.lowercased()) {
                emphasisPoints.append(EmphasisPoint(
                    position: currentTime,
                    word: wordStr,
                    intensity: 0.8,
                    technique: .combination
                ))
            }
            
            currentTime += 0.4
        }
        
        return emphasisPoints
    }
    
    /// Generate delivery instructions
    private func generateDeliveryInstructions(
        dialogue: DialogueBlock,
        characterBackstory: CharacterBackstory,
        emotionalContext: EmotionalContext
    ) -> DeliveryInstructions {
        // Determine acting technique (default to Stanislavski)
        let technique: ActingTechnique = .stanislavski
        
        // Determine focus based on character objectives
        var focus: DeliveryFocus = .objective
        if let objective = characterBackstory.objectives.first {
            if objective.obstacle != nil {
                focus = .obstacle
            } else {
                focus = .objective
            }
        }
        
        // Generate beats from character objectives
        var beats: [Beat] = []
        if let objective = characterBackstory.objectives.first {
            beats.append(Beat(
                startTime: 0,
                duration: 2.0,
                objective: objective.objective,
                tactic: objective.tactics.first ?? "persuade",
                emotionalShift: emotionalContext.primaryEmotion
            ))
        }
        
        // Generate notes
        var notes: String? = nil
        if let subtext = emotionalContext.subtext {
            notes = "Subtext: \(subtext)"
        }
        if let relationship = emotionalContext.relationshipContext {
            notes = (notes ?? "") + "\nRelationship: \(relationship.relationshipType.rawValue) with \(relationship.otherCharacter)"
        }
        
        return DeliveryInstructions(
            technique: technique,
            focus: focus,
            notes: notes,
            beats: beats
        )
    }
    
    /// Extract subtext from dialogue
    private func extractSubtext(from dialogue: String) -> String? {
        // Simple subtext detection (in production, use NLP)
        let lowercased = dialogue.lowercased()
        
        if lowercased.contains("fine") && (lowercased.contains("not") || lowercased.contains("don't")) {
            return "Actually not fine, hiding true feelings"
        }
        
        if lowercased.contains("whatever") {
            return "Dismissive, doesn't want to engage"
        }
        
        if lowercased.contains("i don't care") {
            return "Actually cares deeply, defensive"
        }
        
        return nil
    }
}


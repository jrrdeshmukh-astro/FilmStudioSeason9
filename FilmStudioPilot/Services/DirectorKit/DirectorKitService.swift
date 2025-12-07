//
//  DirectorKitService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import AVFoundation
import CoreMedia

@MainActor
class DirectorKitService: ObservableObject {
    @Published var isProcessing: Bool = false
    
    private let scene3DService: Scene3DService
    private let voiceOverService: VoiceOverService
    
    init(scene3DService: Scene3DService, voiceOverService: VoiceOverService = VoiceOverService()) {
        self.scene3DService = scene3DService
        self.voiceOverService = voiceOverService
    }
    
    /// Convert a screenplay into a directed project with shots, camera setups, and blocking
    func directProject(from screenplay: Screenplay) async -> DirectorProject {
        isProcessing = true
        defer { isProcessing = false }
        
        var directedScenes: [DirectedScene] = []
        
        // Process each screenplay scene
        for screenplayScene in screenplay.scenes {
            let directedScene = await directScene(from: screenplayScene, screenplay: screenplay)
            directedScenes.append(directedScene)
        }
        
        // Create asset catalog
        let assetCatalog = AssetCatalog()
        
        // Create director project
        let project = DirectorProject(
            title: screenplay.title,
            screenplay: screenplay,
            scenes: directedScenes,
            assets: assetCatalog
        )
        
        return project
    }
    
    /// Direct a single screenplay scene into shots with camera setups and blocking
    private func directScene(from screenplayScene: ScreenplayScene, screenplay: Screenplay? = nil) async -> DirectedScene {
        var shots: [Shot] = []
        var currentTime: TimeInterval = 0
        
        // Generate shots based on dialogue and action
        var shotNumber = 1
        
        // Group dialogue by character for shot planning
        let dialogueGroups = groupDialogueByCharacter(screenplayScene.dialogue)
        
        // Create establishing shot if needed
        if shouldCreateEstablishingShot(for: screenplayScene) {
            let establishingShot = createEstablishingShot(
                sceneNumber: screenplayScene.sceneNumber,
                heading: screenplayScene.heading,
                shotNumber: shotNumber
            )
            shots.append(establishingShot)
            currentTime += establishingShot.timing.duration
            shotNumber += 1
        }
        
        // Create shots for dialogue
        for dialogueBlock in screenplayScene.dialogue {
            // Find character backstory if available
            let characterBackstory = findCharacterBackstory(for: dialogueBlock.character, in: screenplay)
            
            let shot = createDialogueShot(
                dialogue: dialogueBlock,
                shotNumber: shotNumber,
                startTime: currentTime,
                previousDialogue: screenplayScene.dialogue.first(where: { $0.id == dialogueBlock.id }),
                characterBackstory: characterBackstory
            )
            shots.append(shot)
            currentTime += shot.timing.duration
            shotNumber += 1
        }
        
        // Create shots for action lines
        for actionLine in screenplayScene.action {
            let shot = createActionShot(
                action: actionLine,
                shotNumber: shotNumber,
                startTime: currentTime
            )
            shots.append(shot)
            currentTime += shot.timing.duration
            shotNumber += 1
        }
        
        // Generate blocking plan
        let blocking = generateBlockingPlan(
            for: screenplayScene,
            shots: shots
        )
        
        // Calculate scene timing
        let sceneTiming = SceneTiming(
            estimatedDuration: currentTime,
            startTime: 0,
            endTime: currentTime
        )
        
        return DirectedScene(
            sceneNumber: screenplayScene.sceneNumber,
            screenplayScene: screenplayScene,
            shots: shots,
            blocking: blocking,
            timing: sceneTiming,
            status: .planned
        )
    }
    
    // MARK: - Shot Creation
    
    private func shouldCreateEstablishingShot(for scene: ScreenplayScene) -> Bool {
        // Create establishing shot for first scene or scene changes
        return scene.sceneNumber == 1 || scene.heading.location != ""
    }
    
    private func createEstablishingShot(
        sceneNumber: Int,
        heading: SceneHeading,
        shotNumber: Int
    ) -> Shot {
        let cameraSetup = CameraSetup(
            position: [0, 2.0, -5.0], // High and wide
            rotation: [0, 0, 0],
            focalLength: 24, // Wide angle
            aperture: 8.0,
            cameraType: .establishing
        )
        
        let framing = Framing(
            composition: .centered,
            ruleOfThirds: true,
            depthOfField: .deep
        )
        
        let duration: TimeInterval = 3.0 // 3 seconds for establishing
        
        return Shot(
            shotNumber: shotNumber,
            cameraSetup: cameraSetup,
            framing: framing,
            timing: ShotTiming(
                duration: duration,
                startTime: 0,
                endTime: duration
            ),
            visualNotes: "Establishing shot of \(heading.location) - \(heading.timeOfDay)"
        )
    }
    
    private func createDialogueShot(
        dialogue: DialogueBlock,
        shotNumber: Int,
        startTime: TimeInterval,
        previousDialogue: DialogueBlock?,
        characterBackstory: CharacterBackstory? = nil
    ) -> Shot {
        // Determine camera type based on dialogue context
        let cameraType: CameraSetup.CameraType
        if dialogue.parenthetical?.lowercased().contains("whisper") == true ||
           dialogue.parenthetical?.lowercased().contains("quiet") == true {
            cameraType = .closeUp
        } else if dialogue.dialogue.count > 100 {
            cameraType = .medium
        } else {
            cameraType = .closeUp
        }
        
        let cameraSetup = CameraSetup(
            position: [0, 1.6, -2.0], // Eye level
            rotation: [0, 0, 0],
            focalLength: cameraType == .closeUp ? 85 : 50,
            aperture: 2.8, // Shallow depth of field for dialogue
            cameraType: cameraType
        )
        
        let framing = Framing(
            composition: .ruleOfThirds,
            ruleOfThirds: true,
            depthOfField: .shallow
        )
        
        // Use voice over service to rig dialogue if character backstory available
        var duration: TimeInterval
        if let backstory = characterBackstory {
            let rigging = voiceOverService.rigDialogue(dialogue, characterBackstory: backstory)
            duration = rigging.timing.duration
        } else {
            // Estimate dialogue duration (average speaking rate: 150 words per minute)
            let wordCount = dialogue.dialogue.split(separator: " ").count
            duration = TimeInterval(wordCount) / 2.5 // words per second
        }
        
        return Shot(
            shotNumber: shotNumber,
            cameraSetup: cameraSetup,
            framing: framing,
            dialogue: [dialogue],
            timing: ShotTiming(
                duration: duration,
                startTime: startTime,
                endTime: startTime + duration
            ),
            visualNotes: "\(dialogue.character): \(dialogue.parenthetical ?? "")"
        )
    }
    
    private func createActionShot(
        action: ActionLine,
        shotNumber: Int,
        startTime: TimeInterval
    ) -> Shot {
        // Determine camera type based on action content
        let cameraType: CameraSetup.CameraType
        if action.text.lowercased().contains("close") {
            cameraType = .closeUp
        } else if action.text.lowercased().contains("wide") || action.text.lowercased().contains("establish") {
            cameraType = .establishing
        } else {
            cameraType = .medium
        }
        
        let cameraSetup = CameraSetup(
            position: [0, 1.6, -3.0],
            rotation: [0, 0, 0],
            focalLength: cameraType == .closeUp ? 85 : 35,
            aperture: 4.0,
            cameraType: cameraType
        )
        
        let framing = Framing(
            composition: .centered,
            ruleOfThirds: true,
            depthOfField: .medium
        )
        
        let duration = action.timing ?? 2.0 // Default 2 seconds for action
        
        return Shot(
            shotNumber: shotNumber,
            cameraSetup: cameraSetup,
            framing: framing,
            action: [action],
            timing: ShotTiming(
                duration: duration,
                startTime: startTime,
                endTime: startTime + duration
            ),
            visualNotes: action.text
        )
    }
    
    // MARK: - Blocking Generation
    
    private func generateBlockingPlan(
        for scene: ScreenplayScene,
        shots: [Shot]
    ) -> BlockingPlan {
        var characterPositions: [BlockingPlan.CharacterPosition] = []
        var movementPaths: [BlockingPlan.MovementPath] = []
        var interactionPoints: [BlockingPlan.InteractionPoint] = []
        
        // Extract characters from dialogue
        let characters = Set(scene.dialogue.map { $0.character })
        
        // Create initial positions for characters
        var currentTime: TimeInterval = 0
        for (index, character) in characters.enumerated() {
            let position = SIMD3<Float>(
                Float(index) * 2.0 - Float(characters.count - 1),
                0,
                0
            )
            
            characterPositions.append(
                BlockingPlan.CharacterPosition(
                    characterName: character,
                    position: position,
                    timing: currentTime
                )
            )
        }
        
        // Create interaction points for dialogue
        for dialogue in scene.dialogue {
            if let otherCharacter = findDialoguePartner(
                for: dialogue.character,
                in: scene.dialogue
            ) {
                interactionPoints.append(
                    BlockingPlan.InteractionPoint(
                        characters: [dialogue.character, otherCharacter],
                        position: [0, 0, 0],
                        interactionType: .dialogue,
                        timing: currentTime
                    )
                )
            }
        }
        
        return BlockingPlan(
            characterPositions: characterPositions,
            movementPaths: movementPaths,
            interactionPoints: interactionPoints
        )
    }
    
    private func findDialoguePartner(
        for character: String,
        in dialogue: [DialogueBlock]
    ) -> String? {
        // Find the next character who speaks after this one
        if let currentIndex = dialogue.firstIndex(where: { $0.character == character }) {
            let nextIndex = dialogue.index(after: currentIndex)
            if nextIndex < dialogue.endIndex {
                return dialogue[nextIndex].character
            }
        }
        return nil
    }
    
    private func groupDialogueByCharacter(_ dialogue: [DialogueBlock]) -> [String: [DialogueBlock]] {
        var groups: [String: [DialogueBlock]] = [:]
        for block in dialogue {
            groups[block.character, default: []].append(block)
        }
        return groups
    }
    
    // MARK: - Timeline Composition
    
    /// Create AVComposition from directed project
    func createComposition(from project: DirectorProject) async throws -> AVMutableComposition {
        let composition = AVMutableComposition()
        
        // Create video and audio tracks
        guard let videoTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid
        ) else {
            throw DirectorKitError.compositionError("Failed to create video track")
        }
        
        guard let audioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
        ) else {
            throw DirectorKitError.compositionError("Failed to create audio track")
        }
        
        // Add shots to timeline
        var currentTime = CMTime.zero
        for scene in project.scenes {
            for shot in scene.shots {
                // In production, this would add actual video/audio assets
                // For now, we're creating the timeline structure
                let duration = CMTime(seconds: shot.timing.duration, preferredTimescale: 600)
                
                // Add placeholder (in production, insert actual media)
                currentTime = CMTimeAdd(currentTime, duration)
            }
        }
        
        return composition
    }
}

enum DirectorKitError: Error {
    case compositionError(String)
    case osfParseError(String)
    case assetNotFound(String)
}


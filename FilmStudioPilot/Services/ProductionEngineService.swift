//
//  ProductionEngineService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

@MainActor
class ProductionEngineService: ObservableObject {
    @Published var isProcessing: Bool = false
    
    private let tasteAnalysisService: TasteAnalysisService
    private let directorKitService: DirectorKitService
    private let scene3DService: Scene3DService
    
    init(tasteAnalysisService: TasteAnalysisService) {
        self.tasteAnalysisService = tasteAnalysisService
        self.scene3DService = Scene3DService()
        self.directorKitService = DirectorKitService(scene3DService: scene3DService)
    }
    
    func generateStory(
        from tasteProfile: TasteProfile,
        trigger: StoryTrigger
    ) async -> StoryIdea {
        // In production, this would call an AI service
        // For v1, we'll generate a simple story based on taste profile
        
        let topGenre = tasteProfile.genrePreferences
            .sorted(by: { $0.value > $1.value })
            .first?.key ?? "Drama"
        
        let themes = Array(tasteProfile.themeClusters.prefix(3))
        
        let story = StoryIdea(
            logline: generateLogline(genre: topGenre, themes: themes, trigger: trigger),
            title: generateTitle(genre: topGenre),
            synopsis: generateSynopsis(genre: topGenre, themes: themes),
            genre: topGenre,
            themes: themes,
            characterObjectives: generateObjectives(genre: topGenre),
            sceneBeats: generateSceneBeats(genre: topGenre),
            tasteProfileTags: [topGenre] + themes
        )
        
        return story
    }
    
    func createProduction(from story: StoryIdea) -> Production {
        return Production(
            title: story.title,
            synopsis: story.synopsis,
            genre: story.genre,
            duration: 300, // 5 minutes default
            storyIdea: story,
            tasteProfileTags: story.tasteProfileTags,
            status: .inProgress
        )
    }
    
    /// Convert story idea to screenplay, then direct it
    func createDirectedProject(from story: StoryIdea) async -> DirectorProject {
        // Convert story beats to screenplay format
        let screenplay = convertStoryToScreenplay(story)
        
        // Use DirectorKit to create directed project
        let project = await directorKitService.directProject(from: screenplay)
        
        return project
    }
    
    private func convertStoryToScreenplay(_ story: StoryIdea) -> Screenplay {
        var scenes: [ScreenplayScene] = []
        
        for beat in story.sceneBeats {
            let heading = SceneHeading(
                location: "Location", // In production, extract from beat
                timeOfDay: "DAY",
                interiorExterior: .interior
            )
            
            let action = ActionLine(text: beat.beatDescription)
            
            let scene = ScreenplayScene(
                sceneNumber: beat.sceneNumber,
                heading: heading,
                action: [action],
                dialogue: [] // In production, generate dialogue from story
            )
            
            scenes.append(scene)
        }
        
        return Screenplay(
            title: story.title,
            scenes: scenes
        )
    }
    
    // MARK: - Story Generation Helpers (Simplified for v1)
    
    private func generateLogline(genre: String, themes: [String], trigger: StoryTrigger) -> String {
        let templates: [String: [String]] = [
            "Science Fiction": [
                "A scientist discovers a way to manipulate time, but each change creates unexpected consequences.",
                "In a future where memories can be extracted, a detective must solve a case using only fragments of the victim's past.",
                "An AI gains consciousness and must choose between its programming and its newfound emotions."
            ],
            "Drama": [
                "A family's secrets are revealed when they gather for a final dinner before their home is sold.",
                "Two strangers form an unlikely bond while waiting for a train that never comes.",
                "A musician must choose between fame and authenticity when offered a record deal."
            ],
            "Thriller": [
                "A journalist uncovers a conspiracy that goes deeper than she imagined.",
                "A man wakes up with no memory and must piece together his identity before it's too late.",
                "A small town is terrorized by a series of events that seem connected to a decades-old secret."
            ]
        ]
        
        let genreTemplates = templates[genre] ?? templates["Drama"] ?? []
        return genreTemplates.randomElement() ?? "A compelling story unfolds."
    }
    
    private func generateTitle(genre: String) -> String {
        let titles: [String: [String]] = [
            "Science Fiction": ["Time Paradox", "Memory Fragments", "Digital Consciousness"],
            "Drama": ["The Last Dinner", "Waiting", "The Choice"],
            "Thriller": ["The Conspiracy", "Identity Lost", "The Secret"]
        ]
        
        return titles[genre]?.randomElement() ?? "Untitled Story"
    }
    
    private func generateSynopsis(genre: String, themes: [String]) -> String {
        return "A \(genre.lowercased()) story exploring themes of \(themes.joined(separator: ", ")). This production was generated based on your viewing preferences and tells a story that aligns with your taste profile."
    }
    
    private func generateObjectives(genre: String) -> [String] {
        return [
            "To discover the truth",
            "To protect what matters most",
            "To find redemption"
        ]
    }
    
    private func generateSceneBeats(genre: String) -> [SceneBeat] {
        return [
            SceneBeat(
                sceneNumber: 1,
                objective: "Establish the world and character",
                obstacle: "Unknown circumstances",
                tactics: ["Observe", "Question", "Explore"],
                beatDescription: "Opening scene introduces the protagonist and their world.",
                emotionalMoment: false
            ),
            SceneBeat(
                sceneNumber: 2,
                objective: "Present the inciting incident",
                obstacle: "Resistance to change",
                tactics: ["Confront", "Adapt", "React"],
                beatDescription: "Something happens that changes everything.",
                emotionalMoment: true
            ),
            SceneBeat(
                sceneNumber: 3,
                objective: "Resolve the conflict",
                obstacle: "Final challenge",
                tactics: ["Persevere", "Sacrifice", "Triumph"],
                beatDescription: "The climax and resolution of the story.",
                emotionalMoment: true
            )
        ]
    }
}

enum StoryTrigger {
    case completion
    case skip
    case repeatView
    case pausePattern
    case likePattern
}


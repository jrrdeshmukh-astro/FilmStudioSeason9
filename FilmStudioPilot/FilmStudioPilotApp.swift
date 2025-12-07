//
//  FilmStudioPilotApp.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import SwiftData

@main
struct FilmStudioPilotApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Production.self,
            StoryIdea.self,
            TasteProfile.self,
            DirectorProject.self,
            Screenplay.self,
            DirectedScene.self,
            AssetCatalog.self,
            CharacterBackstory.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

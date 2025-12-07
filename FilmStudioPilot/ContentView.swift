//
//  ContentView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var tasteProfiles: [TasteProfile]
    @State private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding || !tasteProfiles.isEmpty {
                HomeView()
            } else {
                OnboardingView()
                    .onAppear {
                        checkOnboardingStatus()
                    }
            }
        }
        .onChange(of: tasteProfiles.count) { _, newValue in
            hasCompletedOnboarding = newValue > 0
        }
    }
    
    private func checkOnboardingStatus() {
        hasCompletedOnboarding = !tasteProfiles.isEmpty
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Production.self, TasteProfile.self, StoryIdea.self], inMemory: true)
}

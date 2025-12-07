//
//  OnboardingView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedMovies: Set<UUID> = []
    @State private var hasCompleted = false
    @State private var searchText = ""
    
    @Query private var tasteProfiles: [TasteProfile]
    
    private var availableMovies: [LocalMovie] {
        if searchText.isEmpty {
            return PopularMovies.movies
        } else {
            return PopularMovies.movies.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText) ||
                movie.genre.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if hasCompleted {
                    completionView
                } else {
                    onboardingContent
                }
            }
            .navigationTitle("Welcome to FilmStudio")
        }
    }
    
    private var onboardingContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Select movies you like")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Text("We'll use your preferences to generate personalized productions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search movies or genres...", text: $searchText)
                }
                .padding()
                #if canImport(UIKit)
                .background(Color(uiColor: .systemGray6))
                #else
                .background(Color(NSColor.controlBackgroundColor))
                #endif
                .cornerRadius(10)
                .padding(.horizontal)
                
                movieGrid
                
                Button(action: completeOnboarding) {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedMovies.count >= 5 ? Color.accentColor : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(selectedMovies.count < 5)
                .padding()
            }
        }
    }
    
    private var movieGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(availableMovies) { movie in
                MovieSelectionCard(
                    movie: movie,
                    isSelected: selectedMovies.contains(movie.id)
                ) {
                    toggleSelection(movie.id)
                }
            }
        }
        .padding()
    }
    
    private var completionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("All Set!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your taste profile has been created. Start browsing productions!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func toggleSelection(_ movieId: UUID) {
        if selectedMovies.contains(movieId) {
            selectedMovies.remove(movieId)
        } else {
            selectedMovies.insert(movieId)
        }
    }
    
    private func completeOnboarding() {
        guard selectedMovies.count >= 5 else { return }
        
        // Get selected movies
        let selectedMoviesList = PopularMovies.movies.filter { selectedMovies.contains($0.id) }
        
        // Build taste profile from local movies
        let tasteAnalysisService = TasteAnalysisService()
        let profile = tasteAnalysisService.buildTasteProfileFromLocalMovies(selectedMoviesList)
        
        // Save to SwiftData
        modelContext.insert(profile)
        
        do {
            try modelContext.save()
            hasCompleted = true
        } catch {
            print("Error saving taste profile: \(error)")
        }
    }
}

struct MovieSelectionCard: View {
    let movie: LocalMovie
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Placeholder poster with genre color
                Rectangle()
                    .fill(genreColor(movie.genre))
                    .frame(height: 180)
                    .overlay(
                        VStack {
                            Image(systemName: "film")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.8))
                            if let year = movie.year {
                                Text("\(year)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
                    )
                    .overlay(
                        Group {
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                                    .padding(8)
                            }
                        },
                        alignment: .topTrailing
                    )
                
                Text(movie.title)
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(movie.genre)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func genreColor(_ genre: String) -> Color {
        switch genre.lowercased() {
        case "science fiction", "sci-fi":
            return Color.blue.opacity(0.7)
        case "drama":
            return Color.purple.opacity(0.7)
        case "thriller", "horror":
            return Color.red.opacity(0.7)
        case "action":
            return Color.orange.opacity(0.7)
        case "crime":
            return Color.gray.opacity(0.7)
        default:
            return Color.indigo.opacity(0.7)
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: TasteProfile.self, inMemory: true)
}


//
//  OnboardingView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var movieService: MovieMetadataService
    @State private var selectedMovies: Set<Int> = []
    @State private var isLoading = false
    @State private var hasCompleted = false
    
    @Query private var tasteProfiles: [TasteProfile]
    
    init() {
        // Load API keys from Info.plist
        let tmdbKey = Bundle.main.object(forInfoDictionaryKey: "TMDbAPIKey") as? String ?? ""
        let omdbKey = Bundle.main.object(forInfoDictionaryKey: "OMDbAPIKey") as? String
        _movieService = StateObject(wrappedValue: MovieMetadataService(tmdbAPIKey: tmdbKey, omdbAPIKey: omdbKey))
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
            .task {
                await movieService.loadPopularMovies()
            }
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
                
                if movieService.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    movieGrid
                }
                
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
            ForEach(movieService.popularMovies.prefix(30)) { movie in
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
    
    private func toggleSelection(_ movieId: Int) {
        if selectedMovies.contains(movieId) {
            selectedMovies.remove(movieId)
        } else {
            selectedMovies.insert(movieId)
        }
    }
    
    private func completeOnboarding() {
        guard selectedMovies.count >= 5 else { return }
        
        isLoading = true
        
        // Get selected movie metadata
        let selectedMovieMetadata = movieService.popularMovies.filter { selectedMovies.contains($0.id) }
        
        // Build taste profile
        let tasteAnalysisService = TasteAnalysisService()
        let profile = tasteAnalysisService.buildTasteProfile(from: selectedMovieMetadata)
        
        // Save to SwiftData
        modelContext.insert(profile)
        
        do {
            try modelContext.save()
            hasCompleted = true
        } catch {
            print("Error saving taste profile: \(error)")
        }
        
        isLoading = false
    }
}

struct MovieSelectionCard: View {
    let movie: MovieMetadata
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 180)
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
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: TasteProfile.self, inMemory: true)
}


//
//  MovieMetadataService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

@MainActor
class MovieMetadataService: ObservableObject {
    @Published var trendingMovies: [MovieMetadata] = []
    @Published var popularMovies: [MovieMetadata] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let tmdbClient: TMDbClient
    private let omdbClient: OMDbClient?
    
    init(tmdbAPIKey: String, omdbAPIKey: String? = nil) {
        self.tmdbClient = TMDbClient(apiKey: tmdbAPIKey)
        if let omdbKey = omdbAPIKey {
            self.omdbClient = OMDbClient(apiKey: omdbKey)
        } else {
            self.omdbClient = nil
        }
    }
    
    func loadTrendingMovies() async {
        isLoading = true
        error = nil
        
        do {
            trendingMovies = try await tmdbClient.getTrendingMovies()
        } catch {
            self.error = error
            print("Error loading trending movies: \(error)")
        }
        
        isLoading = false
    }
    
    func loadPopularMovies() async {
        isLoading = true
        error = nil
        
        do {
            popularMovies = try await tmdbClient.getPopularMovies()
        } catch {
            self.error = error
            print("Error loading popular movies: \(error)")
        }
        
        isLoading = false
    }
    
    func searchMovies(query: String) async throws -> [MovieMetadata] {
        return try await tmdbClient.searchMovies(query: query)
    }
}


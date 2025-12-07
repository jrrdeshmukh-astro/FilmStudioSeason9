//
//  TMDbClient.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

class TMDbClient: APIClient {
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getTrendingMovies() async throws -> [MovieMetadata] {
        let url = URL(string: "\(baseURL)/trending/movie/week?api_key=\(apiKey)")!
        let response: MovieMetadataResponse = try await performRequest(
            url: url,
            responseType: MovieMetadataResponse.self
        )
        return response.results
    }
    
    func getPopularMovies(page: Int = 1) async throws -> [MovieMetadata] {
        let url = URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")!
        let response: MovieMetadataResponse = try await performRequest(
            url: url,
            responseType: MovieMetadataResponse.self
        )
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [MovieMetadata] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)")!
        let response: MovieMetadataResponse = try await performRequest(
            url: url,
            responseType: MovieMetadataResponse.self
        )
        return response.results
    }
    
    func getMovieDetails(id: Int) async throws -> MovieMetadata {
        let url = URL(string: "\(baseURL)/movie/\(id)?api_key=\(apiKey)")!
        return try await performRequest(
            url: url,
            responseType: MovieMetadata.self
        )
    }
}


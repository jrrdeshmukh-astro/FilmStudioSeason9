//
//  MovieMetadata.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

struct MovieMetadata: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String?
    let releaseDate: String?
    let genreIDs: [Int]
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var backdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "https://image.tmdb.org/t/p/w1280\(backdropPath)"
    }
}

struct MovieMetadataResponse: Codable {
    let page: Int
    let results: [MovieMetadata]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


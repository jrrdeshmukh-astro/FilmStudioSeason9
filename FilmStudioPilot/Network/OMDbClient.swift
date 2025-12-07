//
//  OMDbClient.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

struct OMDbMovie: Codable {
    let title: String
    let year: String
    let imdbRating: String?
    let genre: String
    let plot: String
    let director: String?
    let actors: String?
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbRating
        case genre = "Genre"
        case plot = "Plot"
        case director = "Director"
        case actors = "Actors"
    }
}

class OMDbClient: APIClient {
    private let apiKey: String
    private let baseURL = "https://www.omdbapi.com"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getMovie(byTitle title: String) async throws -> OMDbMovie {
        let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let url = URL(string: "\(baseURL)/?apikey=\(apiKey)&t=\(encodedTitle)")!
        return try await performRequest(
            url: url,
            responseType: OMDbMovie.self
        )
    }
    
    func searchMovies(query: String) async throws -> [OMDbMovie] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(baseURL)/?apikey=\(apiKey)&s=\(encodedQuery)")!
        
        struct SearchResponse: Codable {
            let search: [OMDbMovie]?
        }
        
        let response: SearchResponse = try await performRequest(
            url: url,
            responseType: SearchResponse.self
        )
        return response.search ?? []
    }
}


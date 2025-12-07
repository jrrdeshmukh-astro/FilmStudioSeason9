//
//  APIClient.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
}

protocol APIClient {
    func request<T: Decodable>(_ endpoint: String, responseType: T.Type) async throws -> T
}

extension APIClient {
    func performRequest<T: Decodable>(
        url: URL,
        responseType: T.Type,
        headers: [String: String] = [:]
    ) async throws -> T {
        var request = URLRequest(url: url)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}


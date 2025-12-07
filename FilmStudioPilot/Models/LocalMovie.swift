//
//  LocalMovie.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation

/// Local movie representation - no external API needed
struct LocalMovie: Identifiable, Codable {
    let id: UUID
    var title: String
    var genre: String
    var year: Int?
    var userDescription: String? // User's description of why they like it
    
    init(
        id: UUID = UUID(),
        title: String,
        genre: String,
        year: Int? = nil,
        userDescription: String? = nil
    ) {
        self.id = id
        self.title = title
        self.genre = genre
        self.year = year
        self.userDescription = userDescription
    }
}

/// Pre-defined popular movies for onboarding (no API needed)
struct PopularMovies {
    static let movies: [LocalMovie] = [
        LocalMovie(title: "Inception", genre: "Science Fiction", year: 2010),
        LocalMovie(title: "The Matrix", genre: "Science Fiction", year: 1999),
        LocalMovie(title: "Blade Runner", genre: "Science Fiction", year: 1982),
        LocalMovie(title: "The Godfather", genre: "Drama", year: 1972),
        LocalMovie(title: "Pulp Fiction", genre: "Crime", year: 1994),
        LocalMovie(title: "The Shawshank Redemption", genre: "Drama", year: 1994),
        LocalMovie(title: "Fight Club", genre: "Drama", year: 1999),
        LocalMovie(title: "Goodfellas", genre: "Crime", year: 1990),
        LocalMovie(title: "The Dark Knight", genre: "Action", year: 2008),
        LocalMovie(title: "Interstellar", genre: "Science Fiction", year: 2014),
        LocalMovie(title: "Parasite", genre: "Thriller", year: 2019),
        LocalMovie(title: "Get Out", genre: "Horror", year: 2017),
        LocalMovie(title: "Mad Max: Fury Road", genre: "Action", year: 2015),
        LocalMovie(title: "Her", genre: "Science Fiction", year: 2013),
        LocalMovie(title: "Ex Machina", genre: "Science Fiction", year: 2014),
        LocalMovie(title: "The Social Network", genre: "Drama", year: 2010),
        LocalMovie(title: "Whiplash", genre: "Drama", year: 2014),
        LocalMovie(title: "Arrival", genre: "Science Fiction", year: 2016),
        LocalMovie(title: "Dune", genre: "Science Fiction", year: 2021),
        LocalMovie(title: "Everything Everywhere All at Once", genre: "Science Fiction", year: 2022),
        LocalMovie(title: "The Silence of the Lambs", genre: "Thriller", year: 1991),
        LocalMovie(title: "Se7en", genre: "Thriller", year: 1995),
        LocalMovie(title: "Memento", genre: "Thriller", year: 2000),
        LocalMovie(title: "The Prestige", genre: "Thriller", year: 2006),
        LocalMovie(title: "No Country for Old Men", genre: "Thriller", year: 2007),
        LocalMovie(title: "There Will Be Blood", genre: "Drama", year: 2007),
        LocalMovie(title: "The Revenant", genre: "Drama", year: 2015),
        LocalMovie(title: "Moonlight", genre: "Drama", year: 2016),
        LocalMovie(title: "The Shape of Water", genre: "Fantasy", year: 2017),
        LocalMovie(title: "Roma", genre: "Drama", year: 2018)
    ]
}


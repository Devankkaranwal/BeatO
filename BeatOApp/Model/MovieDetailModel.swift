//
//  MovieDetailModel.swift
//  BeatOApp
//
//  Created by Devank on 05/03/24.
//

import Foundation

struct MovieDetail: Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let production_companies: [ProductionCompany]
    let production_countries: [ProductionCountry]
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [SpokenLanguage]
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}


struct GenreListResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct ProductionCompany: Codable {
    let id: Int?
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

struct ProductionCountry: Codable {
    let iso31661: String?
    let name: String?
}

struct SpokenLanguage: Codable {
    let englishName: String?
    let iso6391: String?
    let name: String?
}

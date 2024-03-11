//
//  MovieResponseModel.swift
//  BeatOApp
//
//  Created by Devank on 05/03/24.

import Foundation

struct MovieResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]

    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

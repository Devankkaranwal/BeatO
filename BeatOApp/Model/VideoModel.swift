//
//  VideoModel.swift
//  BeatOApp
//
//  Created by Devank on 05/03/24.

import Foundation

struct VideoResponse: Codable {
    let id: Int?
    let results: [Video]
}

struct Video: Codable {
    let id: String?
    let iso_639_1: String?
    let iso_3166_1: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let published_at: String?
}

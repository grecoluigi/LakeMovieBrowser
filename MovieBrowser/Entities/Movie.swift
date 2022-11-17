//
//  Movie.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
    }
}

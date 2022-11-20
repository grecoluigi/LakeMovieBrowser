//
//  Movie.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    var originalTitle : String?
    let posterPath: String?
    let releaseDate: String?
    let overview: String
    var runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
        case runtime
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
      lhs.id == rhs.id
    }

}

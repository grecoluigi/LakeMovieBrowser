//
//  Movie.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

struct MovieModel: Codable, Hashable {
    let id: Int
    let title: String
    var originalTitle : String?
    let posterPath: String?
    let releaseDate: String?
    let overview: String
    var runtime: Int?
    var genres : [GenreModel]?
    var savedPosterImage : Data? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
        case runtime
        case genres
        case savedPosterImage
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
      lhs.id == rhs.id
    }

}

//
//  Configuration.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import Foundation

struct Configuration: Codable {
    let images: Images

    enum CodingKeys: String, CodingKey {
        case images
    }
}

// MARK: - Images
struct Images: Codable {
    let baseURL: String
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

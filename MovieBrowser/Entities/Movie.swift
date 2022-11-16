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
    let poster_path: String?
    let release_date: String
    let overview: String
}

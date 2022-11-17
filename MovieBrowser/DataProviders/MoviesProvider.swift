//
//  MoviesProvider.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

final class MoviesProvider {
    private let apiManager: ApiManager

    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }

    func getMovies(byGenre genre: Int, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        let genreQueryItem = URLQueryItem(name: "with_genres", value: "\(genre)")
        let sortQueryItem = URLQueryItem(name: "sort_by", value: "popularity.desc")
        let pageQueryItem = URLQueryItem(name: "page", value: "\(page)")
        apiManager.makeRequest(request: ApiRequest(endpoint: .discoverMovie, params: [sortQueryItem, genreQueryItem, pageQueryItem])) { (response: Result<MoviesResponse, Error>) in
            switch response {
            case let .success(response):
                completion(.success(response))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
}

struct MoviesResponse: Codable {
    let page : Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

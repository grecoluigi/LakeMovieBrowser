//
//  MovieDetailProvider.swift
//  MovieBrowser
//
//  Created by Luigi on 18/11/2022.
//

import Foundation

final class MovieDetailProvider {
    private let apiManager: ApiManager

    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }

    func getMovieDetails(for movie: MovieModel, completion: @escaping (Result<MovieModel, Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: .movie, urlparams: ["id":"\(movie.id)"])) { (response: Result<MovieModel, Error>) in
            switch response {
            case let .success(response):
                completion(.success(response))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
}

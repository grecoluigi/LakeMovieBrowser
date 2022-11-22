//
//  GenresProvider.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

final class GenresProvider {
    private let apiManager: ApiManager

    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }

    func getGenres(completion: @escaping (Result<[GenreModel], Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: .genres)) { (response: Result<GenresResponse, Error>) in
            switch response {
            case let .success(response):
                completion(.success(response.genres))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
}

private struct GenresResponse: Codable {
    let genres: [GenreModel]
}

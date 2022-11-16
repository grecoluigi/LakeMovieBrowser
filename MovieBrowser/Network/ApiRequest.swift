//
//  ApiRequest.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import Foundation

struct ApiRequest {
    private enum Constants {
        static let defaultBaseURL: URL = URL(string: "https://api.themoviedb.org/3/")!
    }

    let baseURL: URL
    let endpoint: String
    let params: [URLQueryItem]

    init(baseURL: URL = Constants.defaultBaseURL, endpoint: String, params: [URLQueryItem] = []) {
        self.baseURL = baseURL
        self.endpoint = endpoint
        self.params = params
    }
}

//
//  ConfigurationProvider.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import Foundation

final class ConfigurationProvider {
    private let apiManager: ApiManager
    
    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }

    func getConfiguration(completion: @escaping (Result<Configuration, Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: .configuration)) { (response: Result<Configuration, Error>) in
            switch response {
            case let .success(configuration):
                completion(.success(configuration))
            case let .failure(error) :
                completion(.failure(error))
            }
        }
    }
    
    
    

}

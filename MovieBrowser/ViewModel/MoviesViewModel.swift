//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

class MoviesViewModel : NSObject {
    
    private let genresProvider: GenresProvider
    var genres : Dynamic<[Genre]>
    var error : Dynamic<String>
    
    init(genresProvider: GenresProvider) {
        self.genresProvider = genresProvider
        genres = Dynamic<[Genre]>([])
        error = Dynamic<String>("")
    }
    
    func getGenres() {
        genresProvider.getGenres { result in
            switch result {
            case let .success(genres):
                self.genres.value = genres
            case let .failure(error):
                self.error.value = "Cannot get genres, reason: \(error)"
            }
        }

    }
}

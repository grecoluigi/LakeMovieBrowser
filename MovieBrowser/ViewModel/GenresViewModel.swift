//
//  GenresViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 18/11/2022.
//

import Foundation

class GenresViewModel : NSObject {
    private let genresProvider: GenresProvider
    var genres : Dynamic<[GenreModel]>
    var error : Dynamic<String>
    
    init(genresProvider: GenresProvider) {
        self.genresProvider = genresProvider
        genres = Dynamic<[GenreModel]>([])
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

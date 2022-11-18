//
//  GenresViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 18/11/2022.
//

import Foundation

class GenresViewModel : NSObject {
    //Genres
    
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

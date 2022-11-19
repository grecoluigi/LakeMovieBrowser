//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

class MoviesViewModel : NSObject {
    
    // Movies by genre
    private let moviesProvider: MoviesProvider
    var isLoadingMovies : Bool = false
    var currentPage : Int = 1
    var totalPages : Int = 1
    var movies : Dynamic<[Movie]>
    var currentGenreId: Int?
    
    var error : Dynamic<String>
    
    init(moviesProvider: MoviesProvider, genreId: Int) {
        self.moviesProvider = moviesProvider
        currentGenreId = genreId
        movies = Dynamic<[Movie]>([])
        error = Dynamic<String>("")
    }
    

    
    func getMoviesByGenre() {
        guard let currentGenreId = currentGenreId else { fatalError("Did not set genreId")}
        if (ConfigurationSettings.shared.limitMoviesToFifty && movies.value.count >= 50) { return }
        isLoadingMovies = true
        moviesProvider.getMovies(byGenre: currentGenreId, page: currentPage) { result in
            switch result {
            case .success(let movieResponse):
                self.movies.value.append(contentsOf: movieResponse.results)
                self.currentPage = movieResponse.page
                self.totalPages = movieResponse.totalPages
                self.isLoadingMovies = false
            case .failure(let error):
                self.error.value = "Cannot get movies, reason: \(error)"
                self.isLoadingMovies = false
                print(error)
            }
        }
    }
    
    
    func clearMovies() {
        currentGenreId = nil
        currentPage = 1
        totalPages = 1
        self.movies.value = []
    }
}

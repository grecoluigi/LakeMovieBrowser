//
//  MoviesViewModel.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation

class MoviesViewModel : NSObject {
    
    //Genres
    
    private let genresProvider: GenresProvider
    var currentGenreId: Int?
    var genres : Dynamic<[Genre]>
    
    // Movies by genre
    private let moviesProvider: MoviesProvider
    var isLoadingMovies : Bool = false
    var currentPage : Int = 1
    var totalPages : Int = 1
    var movies : Dynamic<[Movie]>
    
    var imageBaseURL : String?
    var imageSize : String?
    
    var error : Dynamic<String>
    
    init(genresProvider: GenresProvider, moviesProvider: MoviesProvider) {
        self.genresProvider = genresProvider
        self.moviesProvider = moviesProvider
        genres = Dynamic<[Genre]>([])
        movies = Dynamic<[Movie]>([])
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
    
    func getMoviesByGenre() {
        guard let currentGenreId = currentGenreId else { fatalError("Did not set genreId")}
        isLoadingMovies = true
        moviesProvider.getMovies(byGenre: currentGenreId, page: currentPage) { result in
            switch result {
            case .success(let movieResponse):
                self.movies.value.append(contentsOf: movieResponse.results)
                self.currentPage = movieResponse.page
                print("Current page: \(movieResponse.page)")
                self.totalPages = movieResponse.totalPages
                print("Total pages: \(movieResponse.totalPages)")
                self.isLoadingMovies = false
            case .failure(let error):
                self.error.value = "Cannot get movies, reason: \(error)"
                self.isLoadingMovies = false
                print(error)
            }
        }
    }
    
    func setupConfiguration() {
        let configurationProvider = ConfigurationProvider(apiManager: ApiManager())
        configurationProvider.getConfiguration { result in
            switch result {
            case .success(let configuration):
                self.imageBaseURL = configuration.images.baseURL
                self.imageSize = configuration.images.posterSizes.first
            case .failure(let error):
                print("Error getting configuration \(error)")
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

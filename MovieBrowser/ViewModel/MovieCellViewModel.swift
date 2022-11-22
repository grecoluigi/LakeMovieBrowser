//
//  MovieCellViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit
import CoreData

class MovieCellViewModel : NSObject {
    

    var posterImage: Dynamic<UIImage>
    let releaseDate: String?
    var movie: MovieModel
    let movieDetailProvider : MovieDetailProvider
    let runtime: Dynamic<String>
    lazy var coreDataStack = CoreDataStack(modelName: Helper.coreDataModelName)
    var error : Dynamic<String>
    var isFavorite : Bool {
        let fetchRequest : NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id == %ld", Int32(movie.id))
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        do {
            let count = try CoreDataStack.shared.managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            self.error.value = ("Error checking for favorite \(error), \(error.userInfo)")
        }
        return false
    }
    
    init(movie: MovieModel, movieDetailProvider: MovieDetailProvider) {
        self.movie = movie
        self.releaseDate = movie.releaseDate?.yearFromDate
        self.posterImage = Dynamic<UIImage>(UIImage(named: "posterPreloading")!)
        self.movieDetailProvider = movieDetailProvider
        self.runtime = Dynamic<String>("")
        error = Dynamic<String>("")
    }
    
    func downloadPosterImage() {
        guard let posterPath = movie.posterPath else { return }
        downloadPosterImage(relativePath: posterPath) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    guard let image = UIImage(data: data) else { return }
                    self?.posterImage.value = image
            }
        }
    }
    
    func getMovieDetails() {
        movieDetailProvider.getMovieDetails(for: movie) { result in
            switch result {
            case .success(let movieDetails):
                if let runtime = movieDetails.runtime {
                    self.movie.runtime = runtime
                    self.runtime.value = Helper.minutesToMinutesAndHours(durationInMinutes: runtime)
                }
                self.movie.originalTitle = movieDetails.originalTitle
                self.movie.genres = movieDetails.genres
            case .failure(let error):
                print("Cannot get movie detail, error \(error)")
            }
        }
    }
    
    func favoriteMove() {
        let movie = Movie(context: CoreDataStack.shared.managedContext)
        movie.id = Int32(self.movie.id)
        movie.title = self.movie.title
        movie.originalTitle = self.movie.originalTitle
        movie.overview = self.movie.overview
        if let runtime = self.movie.runtime {
            movie.runtime = Int32(runtime)
        }
        movie.releaseDate = self.movie.releaseDate
        movie.poster = self.posterImage.value.pngData()
        if let genres = self.movie.genres?.enumerated() {
            for genre in genres {                let fetchRequest : NSFetchRequest<Genre> = Genre.fetchRequest()
                let predicate = NSPredicate(format: "id == %ld", Int32(genre.element.id))
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = predicate
                do {
                    // Find matching genre in CoreData model
                    if let genre = try CoreDataStack.shared.managedContext.fetch(fetchRequest).first {
                        movie.addToGenres(genre)
                    } else { // Create genre if matching genre not found
                        let movieGenre = Genre(context: CoreDataStack.shared.managedContext)
                        movieGenre.id = Int32(genre.element.id)
                        movieGenre.name = genre.element.name
                        movie.addToGenres(movieGenre)
                    }
                } catch let error as NSError {
                    self.error.value = ("Error retrieving favorites \(error), \(error.userInfo)")
                }
            }
        }
        CoreDataStack.shared.saveContext()
    }
    
    func removeFromFavorites() {
        let fetchRequest : NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "id == %ld", Int32(movie.id))
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        do {
            if let movie = try CoreDataStack.shared.managedContext.fetch(fetchRequest).first {
                CoreDataStack.shared.managedContext.delete(movie)
                CoreDataStack.shared.saveContext()
            }
        } catch let error as NSError {
            self.error.value = ("Error removing favorite \(error), \(error.userInfo)")
        }
    }
    
    private func downloadPosterImage(relativePath: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let posterPath = movie.posterPath, let url = ConfigurationSettings.shared.imageURL(from: posterPath) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

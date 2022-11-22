//
//  FavoritesViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 22/11/2022.
//

import Foundation
import CoreData

class FavoritesViewModel : NSObject {
    
    var favorites : Dynamic<[Movie]>
    var currentGenre : GenreModel?
    var favoritesCount : Int {
        return favorites.value.count
    }
    var error : Dynamic<String>
    
    init(genre: GenreModel? = nil) {
        currentGenre = genre
        favorites = Dynamic<[Movie]>([])
        error = Dynamic<String>("")
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.loadFavorites),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: nil)
    }
    
    @objc func loadFavorites() {
        if let currentGenreId = currentGenre?.id {
            let fetchRequest : NSFetchRequest<Genre> = Genre.fetchRequest()
            let predicate = NSPredicate(format: "id == %ld", Int32(currentGenreId))
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = predicate
            do {
                let genre = try CoreDataStack.shared.managedContext.fetch(fetchRequest).first
                guard let movies = genre?.movie?.allObjects else { return }
                var favs : [Movie] = []
                for case let movie as Movie in movies  {
                    favs.append(movie)
                }
                self.favorites.value = favs
            } catch let error as NSError {
                self.error.value = ("Error retrieving favorites \(error), \(error.userInfo)")
            }
        } else {
            do {
                favorites.value = try CoreDataStack.shared.managedContext.fetch(Movie.fetchRequest())
            } catch let error as NSError {
                self.error.value = ("Error retrieving favorites \(error), \(error.userInfo)")
            }
        }
    }
    
    func getMovie(at indexPath: Int) -> Movie {
        return favorites.value[indexPath]
    }
    
}


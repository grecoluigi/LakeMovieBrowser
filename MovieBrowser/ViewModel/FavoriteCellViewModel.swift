//
//  FavoriteCellViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 22/11/2022.
//

import Foundation

class FavoriteCellViewModel : NSObject {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func removeFromFavorites() {
        CoreDataStack.shared.managedContext.delete(movie)
        do {
            try CoreDataStack.shared.managedContext.save()
        } catch let error as NSError {
            print("Error deleting item \(error), \(error.userInfo)")
        }
    }
    
}

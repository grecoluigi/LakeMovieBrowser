//
//  MovieCellViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

class MovieCellViewModel : NSObject {
    
    let title: String
    let posterPath: String?
    let posterImage: UIImage?
    let releaseDate: String?
    let overview: String
    
    init(movie: Movie) {
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate.yearFromDate
        self.posterImage = nil
        self.overview = movie.overview
    }
}

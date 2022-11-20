//
//  MovieCellViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

class MovieCellViewModel : NSObject {
    

    var posterImage: Dynamic<UIImage>
    let releaseDate: String?
    var movie: Movie
    let movieDetailProvider : MovieDetailProvider
    let runtime: Dynamic<String>
    
    init(movie: Movie, movieDetailProvider: MovieDetailProvider) {
        self.movie = movie
        self.releaseDate = movie.releaseDate?.yearFromDate
        self.posterImage = Dynamic<UIImage>(UIImage(named: "posterPreloading")!)
        self.movieDetailProvider = movieDetailProvider
        self.runtime = Dynamic<String>("")
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
                    self.runtime.value = Helper.minutesToMinutesAndHours(durationInMinutes: runtime)
                }
                self.movie.originalTitle = movieDetails.originalTitle
            case .failure(let error):
                print("Cannot get movie detail, error \(error)")
            }
        }
    }
    
    private func downloadPosterImage(relativePath: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let posterPath = movie.posterPath, let url = ConfigurationSettings.shared.imageURL(from: posterPath) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

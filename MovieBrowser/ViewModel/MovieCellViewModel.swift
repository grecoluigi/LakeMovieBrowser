//
//  MovieCellViewModel.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

class MovieCellViewModel : NSObject {
    
    let title: String
    var posterPath: String?
    var posterImage: Dynamic<UIImage>
    let releaseDate: String?
    let overview: String
    
    init(movie: Movie) {
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate.yearFromDate
        self.posterImage = Dynamic<UIImage>(UIImage(named: "posterPreloading")!)
        self.overview = movie.overview
    }
    
    func downloadPosterImage() {
        guard let posterPath = posterPath else { return }
        downloadPosterImage(relativePath: posterPath) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    guard let image = UIImage(data: data) else { return }
                    self?.posterImage.value = image
            }
        }
    }
    
    private func downloadPosterImage(relativePath: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let posterPath = posterPath, let url = ConfigurationSettings.shared.imageURL(from: posterPath) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}

//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Luigi on 18/11/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {

    let movieVM : MovieCellViewModel
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFavoritesButton()
    }


    init(movieVM: MovieCellViewModel) {
        self.movieVM = movieVM
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupUI() {
        let movie = movieVM.movie
        titleLabel.text = movie.title
        self.subtitleLabel.text = ""
        if movie.title != movie.originalTitle {
            subtitleLabel.text = movie.originalTitle
        }
        if let releaseDate = movie.releaseDate {
            subtitleLabel.text != "" ? subtitleLabel.text?.append(" - \(releaseDate)") : subtitleLabel.text?.append("\(releaseDate)")
        }
        posterImageView.image = movieVM.posterImage.value
        overviewLabel.text = movie.overview
    }
    
    func setupFavoritesButton() {
        if movieVM.isFavorite {
            favoritesButton.setTitle("removeFromFavorites".localized, for: .normal)
            favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            favoritesButton.setTitle("addToFavorites".localized, for: .normal)
            favoritesButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if movieVM.isFavorite {
            movieVM.removeFromFavorites()
        } else {
            movieVM.favoriteMove()
        }
        setupFavoritesButton()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    }


    init(movieVM: MovieCellViewModel) {
        self.movieVM = movieVM
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupUI() {
        titleLabel.text = movieVM.title
        subtitleLabel.text = "\(movieVM.title) - \(movieVM.releaseDate)"
        posterImageView.image = movieVM.posterImage.value
        overviewLabel.text = movieVM.overview
        favoritesButton.setTitle("addToFavorites".localized, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
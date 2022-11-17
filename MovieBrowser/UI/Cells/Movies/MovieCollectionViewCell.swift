//
//  MovieCollectionViewCell.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    var cornerRadius: CGFloat = 16.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply rounded corners to contentView
               contentView.layer.cornerRadius = cornerRadius
               contentView.layer.masksToBounds = true
               
               // Set masks to bounds to false to avoid the shadow
               // from being clipped to the corner radius
               layer.cornerRadius = cornerRadius
               layer.masksToBounds = false
               
               // Apply a shadow
               layer.shadowRadius = 8.0
               layer.shadowOpacity = 0.25
               layer.shadowColor = UIColor.black.cgColor
               layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
            // Improve scrolling performance with an explicit shadowPath
            layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: cornerRadius
            ).cgPath
        }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        yearLabel.text = ""
        bodyTextView.text = ""
        durationLabel.text = ""
        posterImageView.image = nil
        super.prepareForReuse()
    }
    

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseDate.yearFromDate
        bodyTextView.text = movie.overview
        if let posterPath = movie.posterPath {
            downloadPosterImage(relativePath: posterPath) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { [weak self] in
                    guard let image = UIImage(data: data) else { return }
                    self?.posterImageView.fade(to: image)
                        }
            }
        }
    }
    
    
    private func downloadPosterImage(relativePath: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/")?.appending(path: relativePath) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
    }


}

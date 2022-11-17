//
//  MovieTableViewCell.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 13
        posterImageView.clipsToBounds = true
        bodyTextView.textContainer.lineFragmentPadding = 0
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        yearLabel.text = ""
        bodyTextView.text = ""
        durationLabel.text = ""
        posterImageView.image = nil
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

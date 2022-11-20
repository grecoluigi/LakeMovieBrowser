//
//  MovieCollectionViewCell.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    var cornerRadius: CGFloat = 16.0
    
    static let identifier = "movieCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var vm : MovieCellViewModel! {
        didSet {
            self.setupBindings()
            self.configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
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
    
    private func setupBindings() {
        vm.posterImage.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.posterImageView.fade(to: self!.vm.posterImage.value)
            }
        }
        
        vm.runtime.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.durationLabel.text = self?.vm.runtime.value
            }
        }
    }

    func configure() {
        titleLabel.text = vm.movie.title
        yearLabel.text = vm.releaseDate?.yearFromDate
        bodyTextView.text = vm.movie.overview
        vm.downloadPosterImage()
        vm.getMovieDetails()
    }

}

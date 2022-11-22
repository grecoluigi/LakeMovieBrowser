//
//  FavoriteCollectionViewCell.swift
//  MovieBrowser
//
//  Created by Luigi on 22/11/2022.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    var cornerRadius: CGFloat = 16.0
    
    static let identifier = "favoriteCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var removeFromFavoritesButton: UIButton!
    
    var vm : FavoriteCellViewModel! {
        didSet {
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
        super.prepareForReuse()
        titleLabel.text = ""
        yearLabel.text = ""
        durationLabel.text = ""
        posterImageView.image = nil
    }

    func configure() {
        titleLabel.text = vm.movie.title
        yearLabel.text = vm.movie.releaseDate?.yearFromDate
        durationLabel.text = Helper.minutesToMinutesAndHours(durationInMinutes: Int(vm.movie.runtime))
        if let imageData = vm.movie.poster {
            self.posterImageView.image = UIImage(data: imageData)
        }
        let buttonTitle = NSMutableAttributedString(string: "removeFromFavorites".localized, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .medium)])
        removeFromFavoritesButton.setAttributedTitle(buttonTitle, for: .normal)
    }

    @IBAction func removeFromFavorites(_ sender: UIButton) {
        vm.removeFromFavorites()
    }
}

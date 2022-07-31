//
//  MovieTableViewCell.swift
//  MovieCoreData
//
//  Created by Apple on 31.07.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieFormatLabel: UILabel!
    @IBOutlet weak var userRating: UserRating!
    
    var userRatingHandler: ((_ rating: Int) -> Void)? {
        didSet {
            guard let userRatingHandler = userRatingHandler else { return }
            userRating.ratingUpdateHandler = userRatingHandler
        }
    }

    func configureCell(_ movie: Movie) {
        movieTitleLabel.text = movie.title
        movieFormatLabel.text = movie.format
        userRating.rating = Int(movie.userRating)
        if let imageData = movie.image {
            movieImageView.image = UIImage(data: imageData)
        }
    }
}

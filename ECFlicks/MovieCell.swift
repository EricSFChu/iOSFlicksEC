//
//  MovieCell.swift
//  ECFlicks
//
//  Created by EricDev on 1/18/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {


    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(movie: MovieModel) {
        posterView.image = nil
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseLabel.text = "Release Date: \(movie.releaseDate)"
        originalLanguageLabel.text = "Original Language: \(movie.originalLanguage.capitalized)"
        posterView.layer.cornerRadius = 3.0
        
        let filePath = movie.posterPath
        
        let imageUrl = URL(string: "\(POSTER_BASE_URL)\(filePath)")
        let imageRequest = URLRequest(url: imageUrl!)
            
        //allow pictures to fade in if it is loading for the first time
        posterView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                    
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    self.posterView.alpha = 0.0
                    self.posterView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.posterView.alpha = 1.0
                    })
                } else {
                    self.posterView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                NSLog("Image: \(error.localizedDescription)")
        })
    }

}

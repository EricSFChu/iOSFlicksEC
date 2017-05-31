//
//  MovieLightCell.swift
//  ECFlicks
//
//  Created by EricDev on 1/27/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class MovieLightCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var jobOrCharacterLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    func configCell(movie: MovieModelLight) {
    
        titleLabel.text = movie.title
        jobOrCharacterLabel.text = movie.jobOrCharacter
        
        let str = "\(POSTER_BASE_URL)\(movie.posterPath)"
        let url = URL(string: str)
        let request = URLRequest(url: url!)
        
        pictureView.setImageWith(
            request,
            placeholderImage: nil,
            success: {(imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                self.pictureView.alpha = 0.0
                self.pictureView.image = image
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.pictureView.alpha = 1.0
                })
            } else {
                self.pictureView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                NSLog("Image: \(error.localizedDescription)")
        })
        
    }
}

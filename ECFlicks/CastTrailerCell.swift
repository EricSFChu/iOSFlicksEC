//
//  CastTrailerCell.swift
//  ECFlicks
//
//  Created by EricDev on 5/29/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit

class CastTrailerCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    
    func configCell(cast: CastModel) {
        
        nameLabel.text = cast.name.capitalized
        characterLabel.text = cast.character.capitalized
        profileImage.layer.cornerRadius = 3.0
        
        let filePath = cast.profilePath
        
        let imageUrl = URL(string: "\(POSTER_BASE_URL)\(filePath)")
        let imageRequest = URLRequest(url: imageUrl!)
        
        profileImage.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    self.profileImage.alpha = 0.0
                    self.profileImage.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.profileImage.alpha = 1.0
                    })
                } else {
                    self.profileImage.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                NSLog("Image: \(error.localizedDescription)")
        })
        
    }
}

//
//  ImageCell.swift
//  ECFlicks
//
//  Created by EricDev on 1/21/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    
    func configureCell(imageURI: String) {
    
        let imageStr = "\(POSTER_BASE_URL)\(imageURI)"
        let imageURL = URL(string: imageStr)
        let imageRequest = URLRequest(url: imageURL!)
        
        pictureView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
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

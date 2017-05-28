//
//  CollectionCell.swift
//  ECFlicks
//
//  Created by EricDev on 1/22/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var collectionImage: UIImageView!
    
    func configureCell(movie: NSDictionary){
        
        if let filePath = movie["poster_path"] as? String {
            
            let imageUrl = URL(string: POSTER_BASE_URL + filePath)
            collectionImage.setImageWith(imageUrl!)
            
        }
        
    }
}

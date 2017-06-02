//
//  SavedMovieCell.swift
//  ECFlicks
//
//  Created by EricDev on 6/1/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit
import SwipeCellKit


class SavedMovieCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var watchedSegmentedController: UISegmentedControl!
    @IBOutlet weak var likedSegmentedController: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func socialButtonPressed(_ sender: UIButton) {
        
    }
    


}

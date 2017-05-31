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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        self.selectedBackgroundView = backgroundView
        // Initialization code
    }
    

}

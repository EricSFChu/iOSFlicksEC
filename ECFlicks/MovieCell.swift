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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

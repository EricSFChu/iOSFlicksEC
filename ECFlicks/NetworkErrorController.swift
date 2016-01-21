//
//  NetworkErrorController.swift
//  ECFlicks
//
//  Created by EricDev on 1/20/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class NetworkErrorController: UIViewController {
    
    @IBOutlet weak var errorButton: UIButton!
    var hidden: Bool = false
    
    @IBAction func buttonClicked(sender: UIButton) {
        performSegueWithIdentifier("backToMain", sender: nil)
    }
    
}
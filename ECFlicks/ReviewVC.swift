//
//  ReviewVC.swift
//  ECFlicks
//
//  Created by EricDev on 6/5/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ReviewVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textBox: UITextView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Now Reviewing: \(String(describing: movie.title!))"
        titleLabel.sizeToFit()
        textBox.layer.cornerRadius = 5.0
        textBox.becomeFirstResponder()
        
        textBox.text = movie.toReview?.review

        
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        let review = Review(context: context)
        review.review = textBox.text as String
        review.created = Date() as NSDate
        movie.toReview = review

        AD.saveContext()

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to cancel? All unsaved information will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

//
//  FullPageViewController.swift
//  ECFlicks
//
//  Created by Eric Chu on 1/22/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class FullPageViewController: UIViewController {

    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!

    
    var movie: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        print(movie)
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie!["poster_path"] as? String {
            
            let imageURL = NSURL(string: baseURL + posterPath)
            fullImage.setImageWithURL(imageURL!)
        
        }
        
        
        
        
        let title = movie!["title"] as! String
        let overview = movie!["overview"] as! String
        
        titleLabel.text = title
        overViewLabel.text = overview
        overViewLabel.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + overViewLabel.frame.size.height + 2*(titleLabel.frame.size.height))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

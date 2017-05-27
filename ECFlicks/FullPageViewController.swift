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
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //let youtubeBaseURL = "https://www.youtube.com/watch?v="
        //the key is key under http://api.themoviedb.org/3/movie/257088/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8e
        
        loadPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.size.height + transparantView.frame.size.height + fullImage.frame.size.height + 49 + (self.navigationController?.navigationBar.frame.height)!)
    }
    
    func loadPage() {
        
        if let posterPath = movie!["poster_path"] as? String {
            
            let smallImageUrl = POSTER_BASE_URL_LOWRES + posterPath
            let largeImageUrl = POSTER_BASE_URL + posterPath
            let smallImageRequest = URLRequest(url: URL(string: smallImageUrl)!)
            let largeImageRequest = URLRequest(url: URL(string: largeImageUrl)!)
            
            let backdropPath = movie!["backdrop_path"] as? String
            if backdropPath != nil{
                let backdropURL = URL(string: POSTER_BASE_URL + backdropPath!)
                self.backdropImage.setImageWith(backdropURL!)
            } else {
                self.backdropImage.setImageWith(URL(string: largeImageUrl)!)
            }
            
            self.fullImage.setImageWith(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.fullImage.alpha = 0.0
                    self.fullImage.image = smallImage;
                    
                    UIView.animate(withDuration: 0.75, animations: { () -> Void in
                        
                        self.fullImage.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.fullImage.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.fullImage.image = largeImage;
                                
                        },
                            failure: { (request, response, error) -> Void in
                                NSLog(error.localizedDescription)
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    NSLog(error.localizedDescription)
            })
            
        }
        
        
        let title = movie!["title"] as! String
        let overview = movie!["overview"] as! String
        
        titleLabel.text = title
        overViewLabel.text = overview
        overViewLabel.sizeToFit()
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVideo" {
            
            let vidView = segue.destination as! VideoViewController
            vidView.movie = self.movie
        }
        
        if segue.identifier == "toReview" {
            
            let reviewView = segue.destination as! ReviewsViewController
            reviewView.id = self.movie!["id"] as! IntegerLiteralType
        }

    }


}

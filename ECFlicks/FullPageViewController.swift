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
    //private var movieInfo: MovieModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //let youtubeBaseURL = "https://www.youtube.com/watch?v="
        //the key is key under http://api.themoviedb.org/3/movie/257088/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed
        //replace 257088 with the id of the movie
        print(movie)
        //movieInfo.MovieModelHelper(movie!)
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let smallBaseURL = "http://image.tmdb.org/t/p/w185"
        
        
        if let posterPath = movie!["poster_path"] as? String {
            
            //let imageURL = NSURL(string: baseURL + posterPath)
            //fullImage.setImageWithURL(imageURL!)
            let smallImageUrl = smallBaseURL + posterPath
            let largeImageUrl = baseURL + posterPath
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrl)!)
        
            let backdropPath = movie!["backdrop_path"] as? String
            if backdropPath != nil{
                let backdropURL = NSURL(string: baseURL + backdropPath!)
                self.backdropImage.setImageWithURL(backdropURL!)
            } else {
                self.backdropImage.setImageWithURL(NSURL(string: largeImageUrl)!)
            }
            
        self.fullImage.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.fullImage.alpha = 0.0
                self.fullImage.image = smallImage;
                
                UIView.animateWithDuration(0.75, animations: { () -> Void in
                    
                    self.fullImage.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.fullImage.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.fullImage.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        
        }
        
        
        let title = movie!["title"] as! String
        let overview = movie!["overview"] as! String
        let releaseDate = movie!["release_date"] as! String
        let average = movie!["vote_average"] as! double_t
        let popularity1 = movie!["popularity"] as! double_t
        
        popularity.text = "Popularity: " +  "\(popularity1)"
        voteAverage.text = "Vote Averaege: " + "\(average)"
        releaseLabel.text = "Release Date: " + releaseDate
        popularity.sizeToFit()
        voteAverage.sizeToFit()
        releaseLabel.sizeToFit()
        titleLabel.text = title
        overViewLabel.text = overview
        overViewLabel.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.origin.y + overViewLabel.frame.size.height + 2*(titleLabel.frame.size.height)) //+ transparantView.frame.size.height)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(sender: AnyObject) {
    UIView.animateWithDuration(2, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut], animations: {
        self.transparantView.frame.origin.y = 568//CGRect(x: 0, y: 568, width: 320, height: 273)
        self.detailView.frame = CGRect(x: 0, y: 568 + self.transparantView.frame.height, width: 320, height: self.detailView.frame.height)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.detailView.frame.origin.y + self.overViewLabel.frame.size.height + 2*(self.titleLabel.frame.size.height))//+ self.transparantView.frame.size.height)
        }, completion: { finished in
    print("Move Successful")
    })
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

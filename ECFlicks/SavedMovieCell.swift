//
//  SavedMovieCell.swift
//  ECFlicks
//
//  Created by EricDev on 6/1/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit
import SwipeCellKit
import CoreData
import Social
import MBProgressHUD

class SavedMovieCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var watchedSegmentedController: UISegmentedControl!
    @IBOutlet weak var likedSegmentedController: UISegmentedControl!
    
    var referenceToMovie: Movie!
    var delegator: MyCustomCellDelegator!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    @IBAction func detailsButtonPressed(_ sender: UIButton) {
        
        var movieObj: MovieModel!
        
        
        let str = "\(BASE_URL)\(String(describing: referenceToMovie.id!))?api_key=\(API_KEY)" as NSString
        let urlStr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let request = URLRequest(url: url!)
        
        MBProgressHUD.showAdded(to: (self.parentViewController?.view)!, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? NSDictionary {
                    
                    movieObj = MovieModel(movie: responseDictionary)
                    self.delegator.callSegueFromCell(myData: movieObj)
                    MBProgressHUD.hide(for: (self.parentViewController?.view)!, animated: false)
                }
            }
        });
        task.resume()

        
    }
    
    
    @IBAction func likeSegmentChanged(_ sender: UISegmentedControl) {
        
        if likedSegmentedController.selectedSegmentIndex == 0 {
            
            referenceToMovie.goodBad = true
            
        } else if likedSegmentedController.selectedSegmentIndex == 1 {
            
            referenceToMovie.goodBad = false
            
        }
        AD.saveContext()
        
    }

    @IBAction func watchSegmentChanged(_ sender: UISegmentedControl) {
        
        if watchedSegmentedController.selectedSegmentIndex == 0 {
            
            referenceToMovie.watchedOrNo = false
            
        } else if watchedSegmentedController.selectedSegmentIndex == 1 {
            
            referenceToMovie.watchedOrNo = true
            
        }
        AD.saveContext()
    }
    
    
    @IBAction func socialButtonPressed(_ sender: UIButton) {
        
        
        
    }
    
    func configureCell(movie: Movie) {
        
        referenceToMovie = movie
        
        nameLabel.text = movie.title

        if movie.backdrop == nil && movie.backdropURI != "" {
            
            let str = "\(POSTER_BASE_URL)\(String(describing: movie.backdropURI!))"
            let url = URL(string: str)
            let request = URLRequest(url: url!)
            
            backdropView.setImageWith(
                request,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    if imageResponse != nil {
                        
                        self.backdropView.alpha = 0.0
                        self.backdropView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.backdropView.alpha = 1.0
                        })
                        
                        movie.backdrop = image
                        AD.saveContext()
                        
                    } else {
                        
                        self.backdropView.image = image
                        
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    NSLog("Image: \(error.localizedDescription)")
                
            })
        } else if movie.backdrop != nil {
            
            backdropView.image = movie.backdrop as? UIImage
            
        } else {
            
            backdropView.image = UIImage(named: "background")
            
        }
        
        watchedSegmentedController.selectedSegmentIndex = movie.watchedOrNo ? 1 : 0
        likedSegmentedController.selectedSegmentIndex = movie.goodBad ? 0 : 1
        
    }
    
    
    @IBAction func showShareOptions(sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Love Movies?", message: "Share the love", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let tweetAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                
                let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterVC?.setInitialText(self.nameLabel.text)
                twitterVC?.add(self.backdropView.image)
                
               self.parentViewController?.present(twitterVC!, animated: true, completion: nil)
                
            } else {
                
                self.showAlertMessage(message: "Please log into your Twitter account.", title: "Just one more thing...")
                
            }
            
        }
        
        
        let facebookPostAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                
                let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookVC?.setInitialText(self.nameLabel.text)
                facebookVC?.add(self.backdropView.image)
                
                self.parentViewController?.present(facebookVC!, animated: true, completion: nil)
                
            } else {
                
                self.showAlertMessage(message: "Please log into your Facebook account.", title: "Just one more thing...")
                
            }
            
        }
        
        let moreAction = UIAlertAction(title: "More Options", style: UIAlertActionStyle.default) { (action) -> Void in
            
            let activityViewController = UIActivityViewController(activityItems: [self.nameLabel.text!, self.backdropView.image!], applicationActivities: nil)
            
            self.parentViewController?.present(activityViewController, animated: true, completion: nil)
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        self.parentViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showAlertMessage(message: String!, title: String!) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Will do!", style: UIAlertActionStyle.default, handler: nil))
        self.parentViewController?.present(alertController, animated: true, completion: nil)
        
    }

    
}

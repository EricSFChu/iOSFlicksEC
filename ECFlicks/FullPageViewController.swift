//
//  FullPageViewController.swift
//  ECFlicks
//
//  Created by Eric Chu on 1/22/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

class FullPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var movie: NSDictionary?
    var movieObj: MovieModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //let youtubeBaseURL = "https://www.youtube.com/watch?v="
        //the key is key under http://api.themoviedb.org/3/movie/257088/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8e
        
        movieObj = MovieModel(movie: movie!)
        movieObj.loadImageURIs() {
            self.imageCollectionView.reloadData()
        }
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        transparantView.layer.cornerRadius = 5.0
        
        loadPage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailView.frame.size.height + transparantView.frame.size.height + fullImage.frame.size.height + 49 + (self.navigationController?.navigationBar.frame.height)! + imageCollectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movieObj._images, movies.count > 3 {
            
            return movies.count
            
        } else if let movies = movieObj._images, movies.count < 4{
            
            return 3
            
        } else {
            
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if (movieObj._images?.count)! > indexPath.row {
            
            cell.configureCell(imageURI: movieObj.getURI(index: indexPath.row))
        
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = imageCollectionView.cellForItem(at: indexPath) as! ImageCell
        let imageView = cell.pictureView
        
        let popUpImageView = UIImageView(image: imageView?.image)
        popUpImageView.frame = UIScreen.main.bounds
        popUpImageView.backgroundColor = .black
        popUpImageView.contentMode = .scaleAspectFit
        popUpImageView.isUserInteractionEnabled = true
        popUpImageView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopUpImageView(tapper:)))
        popUpImageView.addGestureRecognizer(tap)
        
        self.view.addSubview(popUpImageView)
        
        UIView.animate(withDuration: 1, delay: 0, options: [ .curveEaseIn ], animations: { popUpImageView.alpha = 1.0 }, completion: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func dismissPopUpImageView(tapper: UITapGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        tapper.view?.removeFromSuperview()
        
    }
    
    
    
    func loadPage() {
        
        if let posterPath = movie!["poster_path"] as? String {
            
            let smallImageUrl = POSTER_BASE_URL_LOWRES + posterPath
            let largeImageUrl = POSTER_BASE_URL + posterPath
            let smallImageRequest = URLRequest(url: URL(string: smallImageUrl)!)
            let largeImageRequest = URLRequest(url: URL(string: largeImageUrl)!)
            let placeHolderImg = UIImage(named: "background")
            
            self.fullImage.setImageWith(
                smallImageRequest,
                placeholderImage: placeHolderImg,
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

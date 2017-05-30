//
//  FullPageViewController.swift
//  ECFlicks
//
//  Created by Eric Chu on 1/22/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FullPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView2: GADBannerView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var bannerView4: GADBannerView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var movie: NSDictionary?
    var movieObj: MovieModel!
    var popUpImageView: UIImageView!
    var cast = [CastModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        bannerView2.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView2.rootViewController = self
        bannerView2.load(GADRequest())
        bannerView4.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView4.rootViewController = self
        bannerView4.load(GADRequest())
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        movieObj = MovieModel(movie: movie!)
        movieObj.loadImageURIs() {
            self.imageCollectionView.reloadData()
        }
        
        setMovieDetails()
        loadCast() {
            self.tableView.reloadData()
        }
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.delegate = self
        tableView.dataSource = self
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        
        transparantView.layer.cornerRadius = 5.0
        
        loadPage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: transparantView.frame.size.height + fullImage.frame.size.height + (self.navigationController?.navigationBar.frame.height)! + imageCollectionView.frame.size.height + tableView.frame.size.height + bannerView2.frame.size.height + bannerView4.frame.size.height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedController.selectedSegmentIndex == 0 {
           
            return cast.count
        
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastTrailerCell", for: indexPath) as! CastTrailerCell
        if segmentedController.selectedSegmentIndex == 0 {
            
            cell.configCell(cast: cast[indexPath.row])
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieObj.getMovieImageCount() > 3 {
            
            return movieObj.getMovieImageCount()
            
        } else if  movieObj.getMovieImageCount() < 4 {
            
            return 3
            
        } else {
            
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if movieObj.getMovieImageCount() > indexPath.row {
            
            cell.configureCell(imageURI: movieObj.getURI(index: indexPath.row))
        
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = imageCollectionView.cellForItem(at: indexPath) as! ImageCell
    
        
        popUpImageView = UIImageView(image: cell.pictureView.image)
        popUpImageView.frame = UIScreen.main.bounds
        popUpImageView.backgroundColor = .black
        popUpImageView.contentMode = .scaleAspectFit
        popUpImageView.isUserInteractionEnabled = true
        popUpImageView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopUpImageView(tapper:)))
        popUpImageView.addGestureRecognizer(tap)
        
        self.view.addSubview(popUpImageView)
        
        UIView.animate(withDuration: 1, delay: 0, options: [ .curveEaseIn ], animations: { self.popUpImageView.alpha = 1.0 }, completion: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func dismissPopUpImageView(tapper: UITapGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        tapper.view?.removeFromSuperview()
        popUpImageView = nil
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if (popUpImageView != nil && UIDevice.current.orientation.isLandscape) || (popUpImageView != nil && UIDevice.current.orientation.isPortrait)  {
            
            popUpImageView.frame = UIScreen.main.bounds
            
        }
    }
    
    func setMovieDetails(){
        
        movieObj.loadMovieDetails {
            
            self.budgetLabel.text = self.movieObj.budget
            self.runtimeLabel.text = self.movieObj.runtime
            self.genreLabel.text = self.movieObj.genres
            self.productionLabel.text = self.movieObj.productionCompanies
            self.statusLabel.text = self.movieObj.status
            self.voteAverageLabel.text = self.movieObj.voteAverage
            
        }
        
    }
    
    
    
    func loadPage() {
        
        if let posterPath = movie!["poster_path"] as? String {
            
            let smallImageUrl = POSTER_BASE_URL_LOWRES + posterPath
            let largeImageUrl = POSTER_BASE_URL + posterPath
            let smallImageRequest = URLRequest(url: URL(string: smallImageUrl)!)
            let largeImageRequest = URLRequest(url: URL(string: largeImageUrl)!)
            
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
    
    func loadCast(completed: @escaping CompletedDownload) {
        
        let url: NSString = "\(BASE_URL)\(movieObj.id)/credits?api_key=\(API_KEY)" as NSString
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStrUrl = URL(string: urlStr!)
        
        let request = URLRequest(url: urlStrUrl!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
         
                        for cast in (responseDictionary["cast"] as? [NSDictionary])! {

                            if (cast["profile_path"] as? NSNull) != nil {
                            } else {
                            
                                self.cast.append(CastModel(cast: cast))

                            }
                        
                        }
                    }
            }
            completed()
        }
        task.resume()
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

//
//  FullPageViewController.swift
//  ECFlicks
//
//  Created by Eric Chu on 1/22/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MBProgressHUD
import Social
import CoreData

class FullPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var releasedateLabel: UILabel!
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
    @IBOutlet weak var bannerView5: GADBannerView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var movie: NSDictionary?
    var segueMovieObj: MovieModel!
    var movieObj: MovieModel!
    var popUpImageView: UIImageView!
    var cast = [CastModel]()
    var trailers = [TrailerModel]()
    var recommended = [MovieModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigation()
        
        if segueMovieObj != nil {
            
            movieObj = segueMovieObj
            
        } else {
            
            movieObj = MovieModel(movie: movie!)
            
        }
        
        movieObj.loadImageURIs() {
            self.imageCollectionView.reloadData()
        }
        
        setMovieDetails()
        loadCast() {
            self.tableView.reloadData()
        }
        loadTrailers() {}
        loadRecommendations() {}
        setUpBanners()
        setUpViews()
        loadPage()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: transparantView.frame.size.height + fullImage.frame.size.height + (self.navigationController?.navigationBar.frame.height)! + imageCollectionView.frame.size.height + tableView.frame.size.height + bannerView2.frame.size.height + bannerView4.frame.size.height + bannerView5.frame.size.height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentedController.selectedSegmentIndex == 0 {
            
            let person = cast[indexPath.row]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            person.loadBio {
                MBProgressHUD.hide(for: self.view, animated: false)
                self.performSegue(withIdentifier: "ToPersonVC", sender: person)
            }
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            let youtubeURI: String = trailers[indexPath.row].id
            performSegue(withIdentifier: "ToVideoVC", sender: youtubeURI)
            
        } else if segmentedController.selectedSegmentIndex == 2 {
            
            let storyboard = self.storyboard
            let newVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! FullPageViewController

            newVC.segueMovieObj = recommended[indexPath.row]
            
            if let navigation = navigationController {
                navigation.pushViewController(newVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedController.selectedSegmentIndex == 0 {
           
            return cast.count
        
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            return trailers.count
            
        } else if segmentedController.selectedSegmentIndex == 2 {
            
            return recommended.count
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastTrailerCell", for: indexPath) as! CastTrailerCell
        if segmentedController.selectedSegmentIndex == 0 {
            
            cell.configCell(cast: cast[indexPath.row])
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            cell.configCell(trailer: trailers[indexPath.row])
            
        } else if segmentedController.selectedSegmentIndex == 2 {
            
            cell.configCell(recommended: recommended[indexPath.row])
            
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
            self.releasedateLabel.text = self.movieObj.releaseDate
            let title = self.movieObj.title
            let overview = self.movieObj.overview
            
            self.titleLabel.text = title
            self.overViewLabel.text = overview
            self.overViewLabel.sizeToFit()
            
        }
        
    }
    
    
    
    func loadPage() {
        
        let posterPath = movieObj.posterPath
            
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
                    self.fullImage.image = UIImage(named: "background")
            })
        
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

                            if (cast["profile_path"] as? NSNull) == nil {
                                
                                let castMember = CastModel(cast: cast)

                                self.cast.append(castMember)
                                
                            }
                        }
                    }
            }
            completed()
        }
        task.resume()
    }
    
    func loadRecommendations(completed: @escaping CompletedDownload) {
        
        let url: NSString = "\(BASE_URL)\(movieObj.id)/recommendations?api_key=\(API_KEY)" as NSString
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStrUrl = URL(string: urlStr!)
        
        let request = URLRequest(url: urlStrUrl!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    
                    for recommendation in (responseDictionary["results"] as? [NSDictionary])! {
                        
                        if (recommendation["profile_path"] as? NSNull) != nil {
                        } else {
                            
                            self.recommended.append(MovieModel(movie: recommendation))
                            
                        }
                        
                    }
                }
            }
            completed()
        }
        task.resume()
    }
    
    
    func loadTrailers(completed: @escaping CompletedDownload) {
        
        let url: NSString = "\(BASE_URL)\(movieObj.id)/videos?api_key=\(API_KEY)" as NSString
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStrUrl = URL(string: urlStr!)
        
        let request = URLRequest(url: urlStrUrl!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    
                    for trailer in (responseDictionary["results"] as? [NSDictionary])! {
                            
                        self.trailers.append(TrailerModel(trailer: trailer))
                        
                    }
                }
            }
            completed()
        }
        task.resume()
        
    }
    
    func setUpBanners() {
        
        bannerView2.adUnitID = ADMOB3
        //"ca-app-pub-3940256099942544/2934735716"

        bannerView2.rootViewController = self
        bannerView2.load(GADRequest())
        bannerView4.adUnitID = ADMOB4
        //"ca-app-pub-3940256099942544/2934735716"

        bannerView4.rootViewController = self
        bannerView4.load(GADRequest())
        bannerView5.adUnitID = ADMOB5
        //"ca-app-pub-3940256099942544/2934735716"

        bannerView5.rootViewController = self
        bannerView5.load(GADRequest())
    }
    
    func setUpViews() {
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.delegate = self
        tableView.dataSource = self
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        transparantView.layer.cornerRadius = 5.0
        
        segmentedController.addTarget(self, action: #selector(segmentChanged), for: .allEvents)
    }
    
    func segmentChanged() {
        
        tableView.reloadData()
        
    }
    
    func setUpNavigation() {
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
    }
    
    @IBAction func showShareOptions(sender: UIBarButtonItem) {

        let actionSheet = UIAlertController(title: "Love Movies?", message: "Share the love", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let tweetAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                
                let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterVC?.setInitialText(self.movieObj.title)
                twitterVC?.add(self.fullImage.image)
                
                self.present(twitterVC!, animated: true, completion: nil)
                
            } else {
                
                self.showAlertMessage(message: "Please log into your Twitter account.", title: "Just one more thing...")
                
            }
            
        }
        
        
        let facebookPostAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                
                let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookVC?.setInitialText(self.movieObj.title)
                facebookVC?.add(self.fullImage.image)
                
                self.present(facebookVC!, animated: true, completion: nil)
                
            } else {
                
                self.showAlertMessage(message: "Please log into your Facebook account.", title: "Just one more thing...")
                
            }
            
        }
        
        let moreAction = UIAlertAction(title: "More Options", style: UIAlertActionStyle.default) { (action) -> Void in
            
            let activityViewController = UIActivityViewController(activityItems: [self.movieObj.title, self.fullImage.image!], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    

    func showAlertMessage(message: String!, title: String!) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Will do!", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        saveMovie(movie: movieObj)
        
    }
    
    func saveMovie(movie: MovieModel) {
        
        let item = Movie(context: context)
        item.backdropURI = movieObj.backdropPath
        item.id =  movieObj.id
        item.title = movieObj.title
        item.created = Date() as NSDate
        item.goodBad = true
        item.watchedOrNo = false
        item.backdrop = nil
        AD.saveContext()
        
        let alert = UIAlertController(title: "Alert", message: "Your Movie Has Been Saved.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToVideoVC" {
            
            let vidView = segue.destination as! VideoViewController
            vidView.youtubeURI = sender as! String
            
        }
        
        if segue.identifier == "ToPersonVC" {
            
            let personVC = segue.destination as! PersonViewController
            personVC.person = sender as! CastModel
            
        }

    }


}

//
//  PersonViewController.swift
//  ECFlicks
//
//  Created by EricDev on 1/27/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMobileAds

class PersonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    
    var person: CastModel!
    var pictureURIs = [String]()
    var popUpImageView: UIImageView!
    var movies = [MovieModelLight]()
    var crew = [MovieModelLight]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfig()
        loadPage()
        loadPictureURIs() {
            
            self.collectionView.reloadData()
        
        }
        
        loadTableViewData() {
            
            self.tableView.reloadData()
            
        }
        
        segmentedController.addTarget(self, action: #selector(segmentChanged), for: .allEvents)

        self.tableView.reloadData()
    }

    func segmentChanged() {
    
        tableView.reloadData()
    
    }

    func loadTableViewData(completed: @escaping CompletedDownload) {
        
        let str = "\(BASE_URL_PERSON)\(person.id)/movie_credits?api_key=\(API_KEY)"
        let url = URL(string: str)
        
        let request = URLRequest(url: url!)
        
        let task: URLSessionTask = session.dataTask(with: request, completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let castArr = responseDictionary["cast"] {
                        
                        let movies = castArr as! [NSDictionary]
                        
                        for title in movies {

                            let movieLight = MovieModelLight(movieCast: title)
                            self.movies.append(movieLight)
                            
                        }
                    }
                    
                    
                    if let crewArr = responseDictionary["crew"] {
                        
                        let movies = crewArr as! [NSDictionary]
                        
                        for title in movies {
                            
                            let movieLight = MovieModelLight(movieCrew: title)
                            self.crew.append(movieLight)
                                    
                        }
                    }
                    
                    completed()

                }
            }
            
            });
        task.resume()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: profileView.frame.size.height + collectionView.frame.size.height + segmentedController.frame.size.height + tableView.frame.size.height + (self.navigationController?.navigationBar.frame.height)! + profilePicture.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PersonImageCell
        
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if (popUpImageView != nil && UIDevice.current.orientation.isLandscape) || (popUpImageView != nil && UIDevice.current.orientation.isPortrait)  {
            
            popUpImageView.frame = UIScreen.main.bounds
            
        }
        
        if (UIDevice.current.orientation.isLandscape) || (UIDevice.current.orientation.isPortrait)  {
            
            if view.frame.size.height  < 376.0 {
                
                if let navigationBar = navigationController?.navigationBar {
                    navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
                }
                
            }
            
            if view.frame.size.height > 620.0 {
                
                if let navigationBar = navigationController?.navigationBar {
                    navigationBar.setBackgroundImage(UIImage(named:"WideBanner667"), for: .default)
                }
                
            }
            
        }
    }
    
    func dismissPopUpImageView(tapper: UITapGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        tapper.view?.removeFromSuperview()
        popUpImageView = nil
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if pictureURIs.count < 4 {
            
            return 3
            
        } else if pictureURIs.count > 3{
            
            return pictureURIs.count
            
        } else {
            
            return 0
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonImageCell", for: indexPath) as! PersonImageCell
        
        if indexPath.row < pictureURIs.count {
            
            cell.configureCell(imageURI: pictureURIs[indexPath.row])
            
        }
        
        return cell
    
    }
    
    func viewConfig() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.dataSource = self
        tableView.delegate = self
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        profileView.layer.cornerRadius = 5.0
        
        if view.frame.size.width < 376.0 {
            
            if let navigationBar = navigationController?.navigationBar {
                navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
            }
            
        }
        
        if view.frame.size.width > 620.0 {
            
            if let navigationBar = navigationController?.navigationBar {
                navigationBar.setBackgroundImage(UIImage(named:"WideBanner667"), for: .default)
            }
            
        }
        
    }
    
    func loadPage() {
        
        nameLabel.text = person.name
        biographyLabel.text = person.biography
        biographyLabel.sizeToFit()
        dateOfBirthLabel.text = person.birthday
        birthPlaceLabel.text = person.birthPlace
        
        let imageStr = "\(POSTER_BASE_URL)\(person.profilePath)"
        let imageURL = URL(string: imageStr)
        let imageRequest = URLRequest(url: imageURL!)
        
        profilePicture.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    self.profilePicture.alpha = 0.0
                    self.profilePicture.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.profilePicture.alpha = 1.0
                    })
                } else {
                    self.profilePicture.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                NSLog("Image: \(error.localizedDescription)")
        })
        
    }
    
    func loadPictureURIs(completed: @escaping CompletedDownload){
        
        let str = "\(BASE_URL_PERSON)\(person.id)/images?api_key=\(API_KEY)"
        let url = URL(string: str)
        let request = URLRequest(url: url!)
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        for profile in (responseDictionary["profiles"] as? [NSDictionary])! {
                            
                            if let str = profile["file_path"] {
                                
                                self.pictureURIs.append(str as! String)
                                
                            }
                            
                        }
                    }
                }
                completed()
        });
        task.resume()
        
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedController.selectedSegmentIndex == 0 {
            
            return movies.count
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            return crew.count
            
        } else {
            
            return 0

        }
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieLightCell", for: indexPath) as! MovieLightCell
        
        if segmentedController.selectedSegmentIndex == 0 && movies.count > 0{
            
            cell.configCell(movie: movies[indexPath.row])
            
        } else if segmentedController.selectedSegmentIndex == 1 && crew.count > 0{
            
            cell.configCell(movie: crew[indexPath.row])
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var movie: MovieModelLight!
        var movieObj: MovieModel!
        
        if segmentedController.selectedSegmentIndex == 0 {
            
            movie = movies[indexPath.row]
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            movie = crew[indexPath.row]
            
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let str = "\(BASE_URL)\(movie.id!)?api_key=\(API_KEY)" as NSString
        let urlStr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let request = URLRequest(url: url!)
        
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: {(dataOrNil, response, error) in
                if let data = dataOrNil {
                
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options: []) as? NSDictionary {
                        
                            movieObj = MovieModel(movie: responseDictionary)
                        MBProgressHUD.hide(for: self.view, animated: false)
                        let storyboard = self.storyboard
                        let newVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! FullPageViewController
                        
                        newVC.segueMovieObj = movieObj
                        
                        if let navigation = self.navigationController {
                            navigation.pushViewController(newVC, animated: true)
                        }
                    }
                }
        });
        task.resume()
        
        
        
        
    }
    
}

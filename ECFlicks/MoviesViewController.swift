//
//  MoviesViewController.swift
//  ECFlicks
//
//  Created by EricDev on 1/17/16.
//  Copyright © 2016 EricDev. All rights reserved.
//  

import UIKit
import AFNetworking
import MBProgressHUD
import GoogleMobileAds
import SwipeCellKit
import CoreData

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, GADInterstitialDelegate, SwipeTableViewCellDelegate {
    
    
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedController: UISegmentedControl!

    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!
    var movieList: [NSDictionary]!
    var topRated: [NSDictionary]?
    
    var endPoint: String!
    var pageNumber: Int = 1
    var maxPageNumber: Int = 0
    let threshold: CGFloat = 1400.0
    var loading = false
    var isSearching = false
    var interstitial: GADInterstitial!
    var selectedSegment: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedController.selectedSegmentIndex = selectedSegment
        
        interstitial = createAndLoadInterstitial()
        if movies == nil {
            movies = [NSDictionary]()

        }
        filteredData = [NSDictionary]()
        
        viewConfig()
    
        self.tableView.addSubview(self.refreshControl)
        
        if pageNumber == 1 && movies?.count == 0 {
            loadFromSource()
        }
    
    }

    func viewConfig() {
        
        searchBar.isHidden = true
        errorButton.isHidden = true
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    @IBAction func segmentedControllerDidChange(_ sender: UISegmentedControl) {
        if segmentedController.selectedSegmentIndex == 0 {
            
            endPoint = "now_playing"
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            endPoint = "upcoming"

            
        } else if segmentedController.selectedSegmentIndex == 2 {
            
            endPoint = "popular"
            
        } else if segmentedController.selectedSegmentIndex == 3 {
            
            endPoint = "top_rated"
 
        }
        
        pageNumber = 1
        movies = nil
        loadFromSource()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        if currentReachabilityStatus != .notReachable {
            
            self.errorButton.isHidden = true
            loadFromSource()
            
        } else {
            
            self.errorButton.isHidden = false
            
        }
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @IBAction func searchButtonCall(_ sender: UIBarButtonItem) {
        if  (searchBar.isHidden) {
        
            searchBar.isHidden = false
            
        }else {
            
            searchBar.isHidden = true
            searchBar.resignFirstResponder()
        }
    }
    
    
    @IBAction func didClickErrorMessage(_ sender: AnyObject) {
        viewDidAppear(true)
    }
    
    func loadFromSource(){
        
        if pageNumber != 1 && pageNumber >= maxPageNumber {
            
            return
            
        }
        
        if movies == nil {
            
            movies = [NSDictionary]()
            
        }
        
        loading = true
        let pageNumCheck = pageNumber == 1 ? 1 : pageNumber + 1
        pageNumber += 1
        let endPoint2 = endPoint!
        let url : NSString = "\(BASE_URL)\(endPoint2)?api_key=\(API_KEY)&page=\(pageNumCheck)" as NSString
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStrUrl = URL(string: urlStr!)

        let request = URLRequest(url: urlStrUrl!)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        MBProgressHUD.setAnimationDuration(2.0)
        
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        if let pages = responseDictionary["total_pages"] {
                            
                            self.maxPageNumber = pages as! Int
                            
                        }
                        
                        for movie in (responseDictionary["results"] as? [NSDictionary])! {
                            if (movie["poster_path"] as? String) != nil {
                                
                                self.movies?.append(movie)

                            }
                        
                        }
                            self.tableView.reloadData()
                        }
                    
                }
        
                MBProgressHUD.hide(for: self.view, animated: false)
                self.loading = false
        });
        
        task.resume()
    }
    
    @available(iOS 2.0, *)
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            
            return filteredData.count
            
        } else {
            
            return (movies?.count ?? 0)!
            
        }
        
    }
    
    @available(iOS 2.0, *)
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie: MovieModel = isSearching ? MovieModel(movie: filteredData![indexPath.row]) : MovieModel(movie:(movies?[indexPath.row])!)
        
        cell.delegate = self
        cell.configCell(movie: movie)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie: MovieModel = isSearching ? MovieModel(movie: filteredData![indexPath.row]) : MovieModel(movie:(movies?[indexPath.row])!)
        performSegue(withIdentifier: "Full View", sender: movie )
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let saveAction = SwipeAction(style: .default, title: "Save") { action, indexPath in
            if self.isSearching {
                
                self.saveMovie(movie: self.filteredData[indexPath.row])
                
            } else {
                
                self.saveMovie(movie: (self.movies?[indexPath.row])!)
                
            }
        }
        
        saveAction.hidesWhenSelected = true
        saveAction.backgroundColor = UIColor.black
        saveAction.image = UIImage(named: "heart")
        
        return [saveAction]
    }
    
    func saveMovie(movie: NSDictionary) {
        
        let item = Movie(context: context)
        
        
        if let uri = movie["backdrop_path"]{
            
            if uri as? NSNull == nil {
                
                item.backdropURI = uri as? String
            }
            
        }
        
        if let id = movie["id"] {
            
            item.id =  "\(id)"
            
        }
        
        if let title = movie["title"] {
            
            item.title = title as? String
            
        }

        item.created = Date() as NSDate
        item.goodBad = true
        item.watchedOrNo = false
        item.backdrop = nil
        AD.saveContext()

    }
    
    
    
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
        
    }()
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        if !isSearching {
            
            loadFromSource()
            refreshControl.endRefreshing()
            
        }
    }
    
    

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            
            return (movie["title"] as! String ).range(of: searchText, options: .caseInsensitive) != nil
            
        })
        
        if searchText != "" {
            
            isSearching = true
            
        } else {
            
            isSearching = false
            
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        searchBar.isHidden = true
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isSearching {
        
            let contentOffset = tableView.contentOffset.y + view.frame.height
            let maxOffset = tableView.contentSize.height
        
            if !loading && (maxOffset - contentOffset <= threshold) {
            
                self.loading = true
            
                DispatchQueue.main.async(execute: {
        
                    self.loadFromSource()
                    self.loading = false
        
                })
            
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Full View" {
        
            let detailViewController = segue.destination as! FullPageViewController
            detailViewController.segueMovieObj = sender as! MovieModel
            
        } else if segue.identifier == "toCollection" {
            
            let destinationVC = segue.destination as! NewCollectionViewController
            destinationVC.endPoint = endPoint
            destinationVC.movies = movies
            destinationVC.pageNumber = pageNumber
            destinationVC.maxPageNumber = maxPageNumber
            destinationVC.selectedSegment = self.segmentedController.selectedSegmentIndex
            
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        //let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let interstitial = GADInterstitial(adUnitID: ADMOB_INTERSTITIAL_1)

        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
}

//code by Leo
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}



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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!
    var movieList: [NSDictionary]!
    var topRated: [NSDictionary]?
    
    var endPoint: String!
    var pageNumber: Int = 1
    let threshold: CGFloat = 1400.0
    var loading = false
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = [NSDictionary]()
        filteredData = [NSDictionary]()
        
        if pageNumber == 1 {
            loadFromSource()
        }
        
        viewConfig()
        configBanners()
    
        self.tableView.addSubview(self.refreshControl)
    
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
    
    func configBanners() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        let request = GADRequest()
        request.testDevices = [ "108971e7c80d88709604cbc5bbd22fb6" ]
        bannerView.rootViewController = self
        bannerView.load(request)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if currentReachabilityStatus != .notReachable {
            
            self.errorButton.isHidden = true
            loadFromSource()
            
        } else {
            
            self.errorButton.isHidden = false
            
        }
    }
    
    @IBAction func searchButtonCall(_ sender: UIBarButtonItem) {
        if  (searchBar.isHidden) {
        
            searchBar.isHidden = false
            bannerView.isHidden = true
            
        }else {
            
            searchBar.isHidden = true
            bannerView.isHidden = false
            searchBar.resignFirstResponder()
        }
    }
    
    
    @IBAction func didClickErrorMessage(_ sender: AnyObject) {
        viewDidAppear(true)
    }
    
    func loadFromSource(){
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
        

        cell.configCell(movie: movie)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie: MovieModel = isSearching ? MovieModel(movie: filteredData![indexPath.row]) : MovieModel(movie:(movies?[indexPath.row])!)
        performSegue(withIdentifier: "Full View", sender: movie )
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
            
            let destinationNavigationController = segue.destination as! NewCollectionViewController
            destinationNavigationController.endPoint = endPoint
            destinationNavigationController.movies = self.movies
            
        }
    }
}

extension UIView {
    
    
    
}

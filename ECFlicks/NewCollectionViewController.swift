//
//  NewCollectionViewController.swift
//  ECFlicks
//
//  Created by EricDev on 1/24/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MBProgressHUD

class NewCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UISearchBarDelegate{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var backToListView: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tabedBarController: UITabBar!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var endPoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setTabedNavigation()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self

        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        loadFromSource()
        self.collectionView.addSubview(self.refreshControl)
    }
    @IBAction func searchButtonCall(sender: AnyObject) {
        if  (self.searchBar.hidden == true) {
            self.searchBar.hidden = false
            collectionView.frame = CGRect(x: 0, y: 107, width: 320, height: 412)
            self.collectionView.reloadData()
        }else {
            self.searchBar.hidden = true
            collectionView.frame = CGRect(x: 0, y: 63, width: 320, height: 456)
            searchBar.resignFirstResponder()
            self.collectionView.reloadData()
        }
    }
    /*
    func setTabedNavigation() {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Make the Tab Bar Controller the root view controller
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Set up the now playing View Controller
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("collectionNavControl") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! NewCollectionViewController
        nowPlayingViewController.endPoint = "now_playing"
        
        // Set up the now playing View Controller
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("collectionNavControl") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! NewCollectionViewController
        topRatedViewController.endPoint = "top_rated"
        
        // Set up tabbed bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingViewController, topRatedViewController]
        //vc1.view.backgroundColor = UIColor.orangeColor()
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "MovieStrip")
        
        
        //vc2.view.backgroundColor = UIColor.purpleColor()
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "Star")
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @available(iOS 2.0, *)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
        
    }
    @IBAction func segueToListView(sender: AnyObject) {
        performSegueWithIdentifier("Back to list", sender: nil)
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionRe", forIndexPath: indexPath) as! CollectionCell
        
        let movie = filteredData![indexPath.row]
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let filePath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + filePath)
            cell.collectionImage.setImageWithURL(imageUrl!)
        }
        print("row \(indexPath.row)")
        return cell
        
    }
    
    
    
    func loadFromSource(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredData = self.movies
                            self.collectionView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
        });
        task.resume()
    }
    //attempt at implementing refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
   

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        loadFromSource()
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String ).rangeOfString(searchText
                , options: .CaseInsensitiveSearch) != nil
        })
        collectionView.reloadData()
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collectionToFull" {
            print("collection to full segue called")
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let movie = filteredData![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! FullPageViewController
            detailViewController.movie = movie
        }
        
        if segue.identifier == "Back to list" {
            let destinationNavigationController = segue.destinationViewController as! MoviesViewController
            destinationNavigationController.endPoint = endPoint
        }
    }
}
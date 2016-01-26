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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var errorCell: UITableViewCell!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]!
    var movieList: [NSDictionary]!
    var topRated: [NSDictionary]?
    var endPoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.hidden = false
        self.errorCell.hidden = true
        // Display HUD right before next request is made
        
        // MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        loadFromSource()

        //The subview shows the loading
        self.tableView.addSubview(self.refreshControl)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //load view for network error if there is no network
        if Reachability.isConnectedToNetwork() == true {
            self.errorCell.hidden = true
            self.searchBar.hidden = false
            loadFromSource()
        } else {
            self.searchBar.hidden = true
            self.errorCell.hidden = false
            //performSegueWithIdentifier("NetworkError", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func searchButtonCall(sender: AnyObject) {
        if  (self.searchBar.hidden == true) {
            self.searchBar.hidden = false
            //self.tableView.frame.origin.y = 107
            tableView.frame = CGRect(x: 0, y: 107, width: 320, height: 412)
            self.tableView.reloadData()
        }else {
            self.searchBar.hidden = true
            //self.tableView.frame.origin.y = 63
            tableView.frame = CGRect(x: 0, y: 63, width: 320, height: 456)
            searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func didClickErrorMessage(sender: AnyObject) {
        viewDidAppear(true)
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
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredData = self.movies
                    
                            
                            
                            self.tableView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: false)
                
        });
        task.resume()
    
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    @available(iOS 2.0, *)
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let filePath = movie["poster_path"] as? String {
            
            let imageUrl = NSURL(string: baseUrl + filePath)
            let imageRequest = NSURLRequest(URL: imageUrl!)
        //cell.posterView.setImageWithURL(imageUrl!)
        
        
        //allow pictures to fade in if it is loading for the first time
        cell.posterView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        }
        
        print("row \(indexPath.row)")
        return cell
        
    }
    
    
    //attempt at implementing refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        loadFromSource()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String ).rangeOfString(searchText
                , options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Full View" {
            print("list to full segue called")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let movie = filteredData![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! FullPageViewController
            detailViewController.movie = movie
        }
        if segue.identifier == "toCollection" {
            let destinationNavigationController = segue.destinationViewController as! NewCollectionViewController//as! UINavigationController
            //let targetController = destinationNavigationController.topViewController as! NewCollectionViewController
       
            destinationNavigationController.endPoint = endPoint
        }
    }
}
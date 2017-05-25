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
    var pageNumber: Int = 1
    let threshold: CGFloat = 300.0
    var loading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
        }
        
        self.searchBar.isHidden = false
        searchButtonCall(self)
        self.errorCell.isHidden = true
        // Display HUD right before next request is made
        
        // MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        if pageNumber == 1 {
            loadFromSource()
        }
        //The subview shows the loading
        self.tableView.addSubview(self.refreshControl)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //load view for network error if there is no network
        if Reachability.isConnectedToNetwork() == true {
            self.errorCell.isHidden = true
            self.searchBar.isHidden = false
        } else {
            self.searchBar.isHidden = true
            self.errorCell.isHidden = false
            //performSegueWithIdentifier("NetworkError", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func searchButtonCall(_ sender: AnyObject) {
        if  (self.searchBar.isHidden == true) {
            self.searchBar.isHidden = false

            self.tableView.reloadData()
        }else {
            self.searchBar.isHidden = true

            searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func didClickErrorMessage(_ sender: AnyObject) {
        viewDidAppear(true)
    }
    
    func loadFromSource(){
        let pageNumCheck = pageNumber == 1 ? 1 : pageNumber + 1
        pageNumber += 1
        
        let apiKey = "5cac2af0689a8d6cb9c0a63aa3a886e9"
        let endPoint2 = endPoint!
        let url : NSString = "https://api.themoviedb.org/3/movie/\(endPoint2)?api_key=\(apiKey)&page=\(pageNumCheck)" as NSString
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStrUrl = URL(string: urlStr!)
        print(endPoint)
        print(url)
        let request = URLRequest(url: urlStrUrl!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                        for movie in self.movies! {
                            if self.filteredData == nil {
                                self.filteredData = [NSDictionary]()
                            }
                            self.filteredData.append(movie)
                        }
                            //self.filteredData = self.movies
                        
                        
                            self.tableView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: false)
                
        });
        task.resume()
        NSLog("LoadFromSource Called: \(pageNumber)")
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
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let filePath = movie["poster_path"] as? String {
            
            let imageUrl = URL(string: baseUrl + filePath)
            let imageRequest = URLRequest(url: imageUrl!)
        //cell.posterView.setImageWithURL(imageUrl!)
        
        
        //allow pictures to fade in if it is loading for the first time
        cell.posterView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
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
        refreshControl.addTarget(self, action: #selector(MoviesViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        loadFromSource()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String ).range(of: searchText
                , options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = tableView.contentOffset.y + view.frame.height
        let maxOffset = tableView.contentSize.height
        NSLog(String(maxOffset - contentOffset <= threshold) + "ContentOffSet: \(contentOffset) MaxOffSet: \(maxOffset)")
        if !loading && (maxOffset - contentOffset <= threshold) {
            self.loading = true
            
            DispatchQueue.main.async(execute: {
                self.loadFromSource()
                self.loading = false
            })
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Full View" {
            print("list to full segue called")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = filteredData![indexPath!.row]
            
            let detailViewController = segue.destination as! FullPageViewController
            detailViewController.movie = movie
        }
        if segue.identifier == "toCollection" {
            let destinationNavigationController = segue.destination as! NewCollectionViewController//as! UINavigationController
            //let targetController = destinationNavigationController.topViewController as! NewCollectionViewController
       
            destinationNavigationController.endPoint = endPoint
        }
    }
}

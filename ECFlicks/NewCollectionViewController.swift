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
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchButtonCall(self)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.collectionView.addSubview(self.refreshControl)
    }
    
    
    @IBAction func searchButtonCall(_ sender: AnyObject) {
        if  (self.searchBar.isHidden == true) {
            self.searchBar.isHidden = false
            self.collectionView.reloadData()
        }else {
            self.searchBar.isHidden = true
            searchBar.resignFirstResponder()
            self.collectionView.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @available(iOS 2.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movie = movies {
            return movie.count
        } else {
            return 0
        }
        
    }
    @IBAction func segueToListView(_ sender: AnyObject) {
        performSegue(withIdentifier: "Back to list", sender: nil)
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionRe", for: indexPath) as! CollectionCell
        
        let movie = movies![indexPath.row]
        
        if let filePath = movie["poster_path"] as? String {
            
            let imageUrl = URL(string: POSTER_BASE_URL + filePath)
            cell.collectionImage.setImageWith(imageUrl!)
            
        }
        
        print("row \(indexPath.row)")
        return cell
        
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NewCollectionViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
        
    }()
   

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String ).range(of: searchText
                , options: .caseInsensitive) != nil
        })
        
        collectionView.reloadData()
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionToFull" {
            
            print("collection to full segue called")
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            
            let detailViewController = segue.destination as! FullPageViewController
            detailViewController.movie = movie
            
        }
        
        if segue.identifier == "Back to list" {
            
            let destinationNavigationController = segue.destination as! MoviesViewController
            destinationNavigationController.endPoint = endPoint
            
        }
    }
}

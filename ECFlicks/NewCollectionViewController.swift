//
//  NewCollectionViewController.swift
//  ECFlicks
//
//  Created by EricDev on 1/24/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMobileAds

class NewCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UISearchBarDelegate{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var backToListView: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerView3: GADBannerView!
    
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var endPoint: String!
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.isHidden = true
        
        bannerView3.adUnitID = ADMOB2

        //"ca-app-pub-3940256099942544/2934735716"
        bannerView3.rootViewController = self
        bannerView3.load(GADRequest())
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
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
            
            if isSearching {
                
                return (filteredData?.count)!
                
            } else {
                
                return movie.count
                
            }
            
        } else {
            
            return 0
        }
        
    }
    
    @available(iOS 2.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionRe", for: indexPath) as! CollectionCell
        
        if isSearching {
            cell.configureCell(movie: filteredData![indexPath.row])
        } else {
            cell.configureCell(movie: movies![indexPath.row])
        }
        
        return cell
        
    }
   
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func segueToListView(_ sender: AnyObject) {
        performSegue(withIdentifier: "Back to list", sender: nil)
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
        
        collectionView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        searchBar.isHidden = true
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionToFull" {
            
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie: NSDictionary!
            
            if isSearching {
                movie = filteredData![(indexPath?.row)!]
            } else {
                movie = movies![indexPath!.row]
            }
           
            
            let detailViewController = segue.destination as! FullPageViewController
            detailViewController.movie = movie
            
        }
        
        if segue.identifier == "Back to list" {
            
            let destinationNavigationController = segue.destination as! MoviesViewController
            destinationNavigationController.endPoint = endPoint
            
        }
    }
}

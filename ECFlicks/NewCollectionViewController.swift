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

class NewCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate,
UISearchBarDelegate{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var backToListView: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pageNumber: Int = 1
    var maxPageNumber: Int = 0
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var endPoint: String!
    var isSearching = false
    var selectedSegment: Int = 0
    let threshold: CGFloat = 700
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
               configView()
    }
    
    func configView() {
        
        if view.frame.size.width  < 376.0 {
            
            if let navigationBar = navigationController?.navigationBar {
                navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
            }
            
        }
        
        if view.frame.size.width > 620.0 {
            
            if let navigationBar = navigationController?.navigationBar {
                navigationBar.setBackgroundImage(UIImage(named:"WideBanner667"), for: .default)
            }
            
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.isHidden = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
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
    
    @IBAction func searchButtonCall(_ sender: AnyObject) {
        if  (self.searchBar.isHidden == true) {
            
            self.searchBar.isHidden = false
            self.collectionView.reloadData()
            print(endPoint)
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if view.frame.width < 340 {
            
            return CGSize(width: view.frame.width/3.1, height: 110)
            
        } else {
            return CGSize(width: 120, height: 180)
        }
        
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isSearching {
            
            let contentOffset = collectionView.contentOffset.y + view.frame.height
            let maxOffset = collectionView.contentSize.height
            
            if !loading && (maxOffset - contentOffset <= threshold) {
                
                self.loading = true
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadFromSource()
                    self.loading = false
                    
                })
                
            }
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
                            self.collectionView.reloadData()
                    }
                                                                
            }
                                                            
            MBProgressHUD.hide(for: self.view, animated: false)
            self.loading = false
        });
        
        task.resume()
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
        
        if segue.identifier == "ToList" {
            let destinationVC = segue.destination as! MoviesViewController
            destinationVC.endPoint = endPoint
            destinationVC.pageNumber = pageNumber
            destinationVC.maxPageNumber = maxPageNumber
            destinationVC.movies = movies
            destinationVC.selectedSegment = selectedSegment
            
        }
    }
}

//
//  CollectionViewController.swift
//  ECFlicks
//
//  Created by EricDev on 1/22/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MBProgressHUD

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var backToListView: UIBarButtonItem!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadFromSource()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @available(iOS 2.0, *)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
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
        
        let movie = movies![indexPath.row]
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let filePath = movie["poster_path"] as! String
        let imageUrl = NSURL(string: baseUrl + filePath)
        cell.collectionImage.setImageWithURL(imageUrl!)
        
        print("row \(indexPath.row)")
        return cell
        
    }
    


    func loadFromSource(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
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
                            self.collectionView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
        });
        task.resume()
    }

}

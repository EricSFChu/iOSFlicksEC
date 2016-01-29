//
//  ReviewsViewController.swift
//  ECFlicks
//
//  Created by EricDev on 1/27/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    var reviews: [NSDictionary]?
    var id: IntegerLiteralType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        loadFromSource()
        self.tableView.reloadData()
    }
    
    
    
    func loadFromSource(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(apiKey)")
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
                            self.reviews = responseDictionary["results"] as? [NSDictionary]
                            
                            
                            
                            
                            self.tableView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: false)
                
        });
        task.resume()
        
    }

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let reviews = reviews {
            return reviews.count
        } else {
            return 0
        }
        
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath) as! ReviewCell
        let review = reviews![indexPath.row]
        let author = review["author"] as! String
        let content = review["content"] as! String
        
        cell.authorLabel.text = author
        cell.authorLabel.sizeToFit()
        cell.reviewLabel.text = content
        cell.reviewLabel.sizeToFit()
        tableView.rowHeight = cell.reviewLabel.frame.height + 2*cell.authorLabel.frame.height


        print("row \(indexPath.row)")
        return cell
    }
    
    
}
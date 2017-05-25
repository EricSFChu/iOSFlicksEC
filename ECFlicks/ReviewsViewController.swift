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
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        loadFromSource()
        self.tableView.reloadData()
    }
    
    
    
    func loadFromSource(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
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
                            self.reviews = responseDictionary["results"] as? [NSDictionary]
                            
                            
                            
                            
                            self.tableView.reloadData()
                    }
                }
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: false)
                
        });
        task.resume()
        
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let reviews = reviews {
            return reviews.count
        } else {
            return 0
        }
        
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewCell
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

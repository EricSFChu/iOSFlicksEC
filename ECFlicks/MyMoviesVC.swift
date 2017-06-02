//
//  MyMoviesVC.swift
//  ECFlicks
//
//  Created by EricDev on 6/1/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import SwipeCellKit


class MyMoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView8: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanners()
        configView()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in
            // handle action by updating model with deletion
            print("Delete pressed")
        }
        
        deleteAction.image = UIImage(named: "TrashCan")
        deleteAction.backgroundColor = UIColor.black
        
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        //options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMovieCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func configView() {
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupBanners() {
    
        bannerView8.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //ADMOB8
        let request = GADRequest()
        bannerView8.rootViewController = self
        bannerView8.load(request)
    
    }

}

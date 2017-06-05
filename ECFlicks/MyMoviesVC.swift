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

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}

class MyMoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, NSFetchedResultsControllerDelegate, MyCustomCellDelegator {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView8: GADBannerView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController<Movie>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        getSavedMovies()
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if fetchedResultsController.fetchedObjects?.count == 0 {
            
            let alert = UIAlertController(title: "Alert", message: "You have not saved any movies yet. When you do save a movie, it will appear here.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        getSavedMovies()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            
            return sections.count
            
        }
        
        return 0
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in

            context.delete(self.fetchedResultsController.object(at: indexPath))
            AD.saveContext()

        }
        
        deleteAction.hidesWhenSelected = true
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
        
        if let sections = fetchedResultsController.sections{
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
            
        }
        
        return 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMovieCell", for: indexPath) as! SavedMovieCell
        cell.delegate = self
        cell.delegator = self
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func getSavedMovies() {
        
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let likeSort = NSSortDescriptor(key: "goodBad", ascending: false)
        let watchSort = NSSortDescriptor(key: "watchedOrNo", ascending: true)

        
        if segmentedController.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [titleSort]
            
        } else if segmentedController.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [watchSort]
            
        } else if segmentedController.selectedSegmentIndex == 3 {
            
            fetchRequest.sortDescriptors = [likeSort]
        
        }

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
        do {
            
            try controller.performFetch()
            
        } catch let error as NSError {
            
            NSLog(error.description)
            
        }
    }
    
    func configView() {
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named:"background"), for: .default)
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! SavedMovieCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        
        case.move:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
                
            }
            break
        }
        
    }
    
    func configureCell(cell: SavedMovieCell, indexPath: NSIndexPath) {
        
        let movie = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(movie: movie)
        
    }
    
    func callSegueFromCell(myData dataobject: AnyObject){
        
        performSegue(withIdentifier: "ToDetailsVC", sender: dataobject)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToDetailsVC" {
            
            let newVC = segue.destination as! FullPageViewController
            newVC.segueMovieObj = sender as! MovieModel
            
        }
        
    }

}



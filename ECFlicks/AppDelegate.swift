//
//  AppDelegate.swift
//  ECFlicks
//
//  Created by EricDev on 1/12/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var barTintColor: UIColor?
    var selectedImageTintColor: UIColor = UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: APPID)
        sleep(2)
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Selected)
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)], forState:.Normal)
        
        self.barTintColor = UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        //UITabBarItem.appearance().selectedImage = UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Set up the now playing View Controller
        let nowPlayingNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavControl") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endPoint = "now_playing"

        
        let mapViewNavigationController = storyboard.instantiateViewController(withIdentifier: "MapViewNav") as! UINavigationController

        
        let myMoviesNavigationController = storyboard.instantiateViewController(withIdentifier: "CoreDataNavControl") as!  UINavigationController
        
        // Set up tabbed bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, mapViewNavigationController, myMoviesNavigationController]
        tabBarController.tabBar.barTintColor = UIColor.black
        tabBarController.tabBar.tintColor = UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "MovieStrip")
        
        mapViewNavigationController.tabBarItem.title = "Venues Near Me"
        mapViewNavigationController.tabBarItem.image = UIImage(named: "Map")
        
        myMoviesNavigationController.tabBarItem.title = "My Movies"
        myMoviesNavigationController.tabBarItem.image = UIImage(named: "SavedMovies")
        
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NuFlixDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

let AD = UIApplication.shared.delegate as! AppDelegate
let context = AD.persistentContainer.viewContext



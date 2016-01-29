//
//  AppDelegate.swift
//  ECFlicks
//
//  Created by EricDev on 1/12/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //There is an optional tab bar delegate 
        let popularNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavControl") as! UINavigationController
        let popularViewController = popularNavigationController.topViewController as! MoviesViewController
        popularViewController.endPoint = "popular"
        
        // Set up the now playing View Controller
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavControl") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endPoint = "now_playing"

        // Set up the top Rated View Controller
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavControl") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endPoint = "top_rated"
        
        // Set up the upcoming View Controller
        let upcomingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavControl") as! UINavigationController
        let upcomingViewController = upcomingNavigationController.topViewController as! MoviesViewController
        upcomingViewController.endPoint = "upcoming"
        
        // Set up tabbed bar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController, popularNavigationController, upcomingNavigationController]
        
        
        //vc1.view.backgroundColor = UIColor.orangeColor()
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "MovieStrip")
        

        //vc2.view.backgroundColor = UIColor.purpleColor()
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "Star")
        
        popularNavigationController.tabBarItem.title = "Popular"
        popularNavigationController.tabBarItem.image = UIImage(named: "heart")
        
        upcomingNavigationController.tabBarItem.title = "Upcoming"
        upcomingNavigationController.tabBarItem.image = UIImage(named: "arrow")
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


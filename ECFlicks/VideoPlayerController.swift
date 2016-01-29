//
//  VideoPlayerController.swift
//  ECFlicks
//
//  Created by EricDev on 1/26/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit

enum AwfulError: ErrorType {
    case Bad
    case Worse
    case Terrible
}

class VideoViewController: UIViewController {
    @IBOutlet weak var videoView: UIWebView!
    var endPoint: String = "ncvFAm4kYCo"
    var movie: NSDictionary?
    var youtubeDict: [NSDictionary]?
    var youtube: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let movieID = movie!["id"] as! IntegerLiteralType
       // let apiBaseURL = "http://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        let url = NSURL(string:"http://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        print(url)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
            data, options:[]) as? NSDictionary {
                print("response: \(responseDictionary)")
                self.youtubeDict = responseDictionary["results"] as? [NSDictionary]
                print(self.youtubeDict)
                //endPoint = youtubeDict!["key"] as! String

                    
                //Can cause array out of bounds exception
                if self.youtubeDict?.count != 0 {
                    self.youtube = (self.youtubeDict?[0])! as NSDictionary
                
                print(self.youtube!["key"] as! String)
                let youString = self.youtube!["key"] as! String
                print(youString)
/*
                    let youtubeURL: String = "http://www.youtube.com/embed/\(youString)?rel=0&autoplay=1"

                let width = 330
                let height = 240
                let frame = 0
                let marginY = 0
                let marginX = 0
               // let code: NSString = "<iframe width='\(width)' height='\(height)' src='\(youtubeURL)' frameborder='\(frame)' marginheight='\(marginY)' marginwidth='\(marginX)' allowfullscreen></iframe>";
                let code: NSString = "<iframe src='\(youtubeURL)' allowfullscreen></iframe>";
                self.videoView.loadHTMLString(code as String, baseURL: nil)
                  // let uul = NSURL(string: "www.youtube.com")
                    //self.videoView.loadHTMLString("<iframe src='www.youtube.com' ></iframe>", baseURL: nil)*/
                    
                    let urlPath = "http://www.youtube.com/watch?v=\(youString)"

                        let requestUrl = NSURL(string: urlPath)
                        let request = NSURLRequest(URL: requestUrl!)
                        self.videoView.loadRequest(request)
                }
                    }
                
                }
        });
        task.resume()
        
        //print(youtubeDict)
        //let endPoint = youtube!["key"] as! String

}
}

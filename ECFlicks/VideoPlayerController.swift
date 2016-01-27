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

                    
                
                self.youtube = (self.youtubeDict?[0])! as NSDictionary
                
                print(self.youtube!["key"] as! String)
                let youString = self.youtube!["key"] as! String
                print(youString)
                let youtubeURL: String = "http://www.youtube.com/embed/\(youString)"
                let width = 300
                let height = 200
                let frame = 10
                let code: NSString = "<iframe width=\(width) height=\(height) src=\(youtubeURL) frameborder=\(frame) allowfullscreen></iframe>";
                self.videoView.loadHTMLString(code as String, baseURL: nil)
                }
                
                
                }
        });
        task.resume()
        
        //print(youtubeDict)
        //let endPoint = youtube!["key"] as! String

}
}

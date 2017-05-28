//
//  VideoPlayerController.swift
//  ECFlicks
//
//  Created by EricDev on 1/26/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MBProgressHUD

class VideoViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var videoView: UIWebView!
    
    var endPoint: String = "ncvFAm4kYCo"
    var movie: NSDictionary?
    var youtubeDict: [NSDictionary]?
    var youtube: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        videoView.delegate = self

        loadVideo()
        
    }
    
    func loadVideo() {
        
        let movieID = movie!["id"] as! IntegerLiteralType
        
        let url = URL(string:"\(BASE_URL)\(movieID)/videos?api_key=\(API_KEY)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    MBProgressHUD.showAdded(to: self.view, animated: true)

                        print("response: \(responseDictionary)")
                        self.youtubeDict = responseDictionary["results"] as? [NSDictionary]
                                                                
                        if self.youtubeDict?.count != 0 {
                            
                            self.youtube = (self.youtubeDict?[0])! as NSDictionary
                                                                    
                                let youString = self.youtube!["key"] as! String
                                let urlPath = "\(BASE_YOUTUBE_URL)\(youString)"
                                let requestUrl = URL(string: urlPath)
                                let request = URLRequest(url: requestUrl!)
                                self.videoView.loadRequest(request)
                        
                        }
                    }
                }
        });
        task.resume()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.isLoading {
            return
        }
       
        MBProgressHUD.hide(for: self.view, animated: false)
        
    }
}

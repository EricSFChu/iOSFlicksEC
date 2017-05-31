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
    
    var youtubeURI: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoView.delegate = self
        
        setupNav()
        loadVideo()
        
    }
    
    func loadVideo() {
        
        let urlPath = "\(BASE_YOUTUBE_URL)\(youtubeURI!)"
        let requestUrl = URL(string: urlPath)
        let request = URLRequest(url: requestUrl!)
        self.videoView.loadRequest(request)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.isLoading {
            return
        }
       
        MBProgressHUD.hide(for: self.view, animated: false)
        
    }
    
    func setupNav(){
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        
    }
}

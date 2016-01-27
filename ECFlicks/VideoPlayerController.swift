//
//  VideoPlayerController.swift
//  ECFlicks
//
//  Created by EricDev on 1/26/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class VideoViewController: UIViewController {
    
    var moviePlayer:AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
        /*
        moviePlayer = AVPlayerViewController(url)
        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullScreen = true
        
        moviePlayer.controlStyle = AVPlayerControl.Embedded
        */
    }
}
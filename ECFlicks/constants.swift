//
//  constants.swift
//  ECFlicks
//
//  Created by EricDev on 5/24/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.themoviedb.org/3/movie/"
let POSTER_BASE_URL = "http://image.tmdb.org/t/p/w500"
let POSTER_BASE_URL_LOWRES = "http://image.tmdb.org/t/p/w185"
let BASE_YOUTUBE_URL = "http://www.youtube.com/watch?v="
let BASE_YT_IMG_URL = "https://img.youtube.com/vi/"
let BASE_YT_IMG_END = "/0.jpg"

let session = URLSession(
    configuration: URLSessionConfiguration.default,
    delegate:nil,
    delegateQueue:OperationQueue.main
)

typealias CompletedDownload = () -> ()


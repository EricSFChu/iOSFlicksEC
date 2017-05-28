//
//  constants.swift
//  ECFlicks
//
//  Created by EricDev on 5/24/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.themoviedb.org/3/movie/"
let API_KEY = "5cac2af0689a8d6cb9c0a63aa3a886e9"
let POSTER_BASE_URL = "http://image.tmdb.org/t/p/w500"
let POSTER_BASE_URL_LOWRES = "http://image.tmdb.org/t/p/w185"
let BASE_YOUTUBE_URL = "http://www.youtube.com/watch?v="

let session = URLSession(
    configuration: URLSessionConfiguration.default,
    delegate:nil,
    delegateQueue:OperationQueue.main
)

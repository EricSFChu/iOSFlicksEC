//
//  MovieModel.swift
//  ECFlicks
//
//  Created by EricDev on 1/27/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import Foundation
import UIKit

class MovieModel
{
    let id: String!
    let originalLanguage: String!
    let title: String!
    let overview: String!
    let popularity: String!
    let posterPath: String!
    let releaseDate: String!
    let backdropPath: String!
    let voteCount: String!
    let voteAverage: String!
    
    init (movie: NSDictionary)
    {
        id = "\(String(describing: movie["id"]))"
        originalLanguage = movie["original_language"] as! String
        title = movie["title"] as! String
        overview = movie["overview"] as! String
        popularity = "\(String(describing: movie["popularity"]))"
        posterPath = movie["poster_path"] as! String
        releaseDate = movie["release_date"] as! String
        backdropPath = movie["backdrop_path"] as! String
        voteCount = "\(String(describing: movie["vote_count"]))"
        voteAverage = "\(String(describing: movie["vote_average"]))"
    }
}

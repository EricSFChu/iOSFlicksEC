//
//  MovieModel.swift
//  ECFlicks
//
//  Created by EricDev on 1/27/16.
//  Copyright © 2016 EricDev. All rights reserved.
//

import Foundation
import UIKit

private class MovieModel
{
    let id: String!
    let originalLanguage: String!
    let title: String!
    let overview: String!
    let popularity: String!
    let posterPath: String!
    let releaseDate: String!
    
    init (m: NSDictionary)
    {
        id = m["id"] as! String
        originalLanguage = m["original_language"] as! String
        title = m["title"] as! String
        overview = m["overview"] as! String
        popularity = m["popularity"] as! String
        posterPath = m["poster_path"] as! String
        releaseDate = m["release_date"] as! String
    }
}

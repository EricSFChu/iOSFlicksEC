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
    private var _id: String!
    private var _originalLanguage: String!
    private var _title: String!
    private var _overview: String!
    private var _popularity: String!
    private var _posterPath: String!
    private var _releaseDate: String!
    private var _backdropPath: String!
    private var _voteCount: String!
    private var _voteAverage: String!
    private var _images: [String]!
    
    var id: String {
        return _id
    }
    
    var originalLanguage: String {
        return _originalLanguage
    }
    
    var title: String {
        return _title
    }
    
    var overview: String {
        return _overview
    }
    
    var popularity: String {
        return _popularity
    }
    
    var posterPath: String {
        if _posterPath == nil {
            _posterPath = ""
        }
        return _posterPath
    }
    
    var releaseDate: String {
        return _releaseDate
    }
    
    var backdropPath: String {
        return _backdropPath
    }
    
    var voteCount: String {
        return _voteCount
    }
    
    var voteAverage: String {
        return _voteAverage
    }
    
    init (movie: NSDictionary)
    {
        _id = "\(String(describing: movie["id"]))"
        _originalLanguage = movie["original_language"] as! String
        _title = movie["title"] as! String
        _overview = movie["overview"] as! String
        _popularity = "\(String(describing: movie["popularity"]))"
        
        if let poster = movie["poster_path"] {
           
            self._posterPath = poster as? String
        
        }
        
        
        
        _releaseDate = movie["release_date"] as! String
        
        if let backdrop = movie["backdrop_path"] {
 
            self._backdropPath = backdrop as? String
    
        }
        _voteCount = "\(String(describing: movie["vote_count"]))"
        _voteAverage = "\(String(describing: movie["vote_average"]))"
    }
    
    func loadImages() {
        
        
        
    }
}

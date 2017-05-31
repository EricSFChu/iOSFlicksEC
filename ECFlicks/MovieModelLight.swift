//
//  MovieModelLight.swift
//  ECFlicks
//
//  Created by EricDev on 5/31/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation

class MovieModelLight {
    
    private var _title: String!
    private var _posterPath: String!
    private var _jobOrCharacter: String!
    private var _id: String!
    
    var title: String {
        
        if _title == nil {
            
            _title = ""
            
        }
        
        return _title
        
    }
    
    var posterPath: String {
        
        if _posterPath == nil {
            
            _posterPath = ""
            
        }
        
        return _posterPath
        
    }
    
    var jobOrCharacter: String {
        
        if _jobOrCharacter == nil {
            
            _jobOrCharacter = ""
            
        }
        
        return _jobOrCharacter
        
    }
    
    var id: String! {
        
        if _id == nil {
            
            _id = ""
            
        }
        
        return _id
        
    }
    
    init(movieCast: NSDictionary) {
        
        if movieCast["character"] as? NSNull == nil {
            
            self._jobOrCharacter = movieCast["character"] as! String
            
        }
        
        if movieCast["title"] as? NSNull == nil {
            
            self._title = movieCast["title"] as! String
            
        }
        
        if movieCast["poster_path"] as? NSNull == nil {
            
            self._posterPath = movieCast["poster_path"] as! String
            
        }
        
        if movieCast["id"] as? NSNull == nil {
            
            let id = movieCast["id"] as! Int

            self._id = "\(id)"
            
        }
        
    }
    
    init(movieCrew: NSDictionary) {
        
        if movieCrew["job"] as? NSNull == nil {
            
            self._jobOrCharacter = movieCrew["job"] as! String
            
        }
        
        if movieCrew["title"] as? NSNull == nil {
            
            self._title = movieCrew["title"] as! String
            
        }
        
        if movieCrew["poster_path"] as? NSNull == nil {
            
            self._posterPath = movieCrew["poster_path"] as! String
            
        }
        
        if movieCrew["id"] as? NSNull == nil {
            
            let id = movieCrew["id"] as! Int
            
            self._id = "\(id)"
            
        }
        
    }
    
}

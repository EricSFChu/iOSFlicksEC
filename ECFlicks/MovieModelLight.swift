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
    
    init(movie: NSDictionary) {
        
        
        
    }
    
}

//
//  CastModel.swift
//  ECFlicks
//
//  Created by EricDev on 5/28/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation

class CastModel {
    
    private var _name: String!
    private var _id: String! //is int from JSON
    private var _character: String!
    private var _creditId: String!
    private var _profilePath: String! //imageURI
    
    var name: String {
        
        return _name
        
    }
    
    var id: String {
        
        return _id
        
    }
    
    var character: String {
        
        return _character
        
    }
    
    var creditId: String {
        
        return _creditId
        
    }
    
    var profilePath: String {
        
        return _profilePath
        
    }
    
    
    init (cast: NSDictionary) {
        
        self._name = cast["name"]! as! String
        self._id = "\(String(describing: cast["id"]))"
        self._character = cast["character"] as! String
        self._creditId = cast["credit_id"] as! String
        self._profilePath = cast["profile_path"] as! String
        
    }
    
}

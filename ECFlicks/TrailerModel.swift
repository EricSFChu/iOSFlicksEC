//
//  TrailerModel.swift
//  ECFlicks
//
//  Created by EricDev on 5/28/17.
//  Copyright © 2017 EricDev. All rights reserved.
//

import Foundation

class TrailerModel {
    
    private var _id: String!
    private var _name: String!
    
    var id: String {
        
        if _id == nil {
            _id = ""
        }
        
        return _id
        
    }
    
    var name: String {
        
        if _name == nil {
            _name = ""
        }
        
        return _name
    }
    
    init (trailer: NSDictionary) {
        
        if let id = trailer["key"] {
            
            _id = id as! String
            
        }
        
        if let name = trailer["name"] {
            
            _name = name as! String
        }
        
    }
    
}

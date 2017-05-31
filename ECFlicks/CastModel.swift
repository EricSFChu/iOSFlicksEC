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
    private var _biography: String!
    private var _birthday: String!
    private var _birthPlace: String!
    
    var biography: String {
        
        if _biography == nil {
            
            _biography = ""
            
        }
        
        return _biography
    }
    
    var birthday: String {
        
        if _birthday == nil {
            
            _birthday = ""
            
        }
        
        return _birthday
        
    }
    
    var birthPlace: String {
        
        if _birthPlace == nil {
            
            _birthPlace = ""
            
        }
        
        return _birthPlace
        
    }
    
    var name: String {
        
        if _name == nil {
            
            _name = ""
        
        }
        
        return _name
        
    }
    
    var id: String {
        
        if _id == nil {
            
            _id = ""
            
        }
        
        return _id
        
    }
    
    var character: String {
        
        if _character == nil {
            
            _character = ""
            
        }
        
        return _character
        
    }
    
    var creditId: String {
        
        if _creditId == nil {
            
            _creditId = ""
            
        }
        
        return _creditId
        
    }
    
    var profilePath: String {
        
        if _profilePath == nil {
            
            _profilePath = ""
            
        }
        
        return _profilePath
        
    }
    
    
    init (cast: NSDictionary) {
        
        if cast["name"] as? NSNull == nil {
            
            self._name = cast["name"]! as! String
            
        }
        
        if cast["id"] as? NSNull == nil {
            
            self._id = "\(String(describing: (cast["id"]! as! Int)))"
            
        }
        
        if cast["character"] as? NSNull == nil {
            
            self._character = cast["character"] as! String
            
        }
        
        if cast["credit_id"] as? NSNull == nil {
            
           self._creditId = cast["credit_id"] as! String
            
        }
        
        if  cast["profile_path"] as? NSNull == nil {
            
            self._profilePath = cast["profile_path"] as! String
            
        }
        
    }
    
    func loadBio(completed: @escaping CompletedDownload) {
        
        let str = "\(BASE_URL_PERSON)\(_id!)?api_key=\(API_KEY)" as NSString
        let url = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStr = URL(string: url!)
        let request = URLRequest(url: urlStr!)
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                {
                    if responseDictionary["biography"] as? NSNull == nil && responseDictionary["biography"] != nil {
                        
                       self._biography = responseDictionary["biography"] as! String
                        
                    }
                    
                    if responseDictionary["birthday"] as? NSNull == nil && responseDictionary["birthday"] != nil {
                        
                        self._birthday = responseDictionary["birthday"] as! String
                        
                    }
                    
                    if responseDictionary["place_of_birth"] as? NSNull == nil && responseDictionary["place_of_birth"] != nil {
                        
                        self._birthPlace = responseDictionary["place_of_birth"] as! String
                        
                    }
                    
                    
                }
            }
            completed()
        });
        task.resume()
    }
}

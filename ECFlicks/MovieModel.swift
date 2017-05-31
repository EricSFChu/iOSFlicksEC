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
    private var _status: String!
    private var _budget: Int!
    private var _runtime: Int!
    private var _imdbId: String!
    
    fileprivate var _genre: [String]?
    fileprivate var _images: [String]?
    fileprivate var _productionCompanies: [String]?
    
    var id: String {
        
        return _id
        
    }
    
    var productionCompanies: String {
        
        var str: String = ""
        
        if _productionCompanies != nil && _productionCompanies?.count != 0 {
            
            for company in _productionCompanies! {

                str += "\(company), "
                
            }
            
            str = str.replacingOccurrences(of: ",\\s$", with: "", options: .regularExpression)
            
        }
        
        return str
        
    }
    
    var genres: String {
        
        var str: String = ""
        
        if _genre != nil && _genre?.count != 0 {
            
            for genre in _genre! {
                
                str += "\(genre), "
                
            }
            
            str = str.replacingOccurrences(of: ",\\s$", with: "", options: .regularExpression)
        }
        
        return str

    }
    
    var status: String {
        
        return _status
        
    }
    
    var budget: String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNum = numberFormatter.string(from: NSNumber(value: _budget))
        
        return "$\(String(describing: formattedNum!))"
        
    }
    
    var runtime: String {
        
        let hours = _runtime / 60
        let minutes = _runtime % 60
        
        return "\(hours)hr \(minutes)m"
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: _releaseDate)
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        return "\(dateFormatter.string(from: date!))"
    }
    
    var backdropPath: String {
        
        return _backdropPath
        
    }
    
    var voteCount: String {
        
        return _voteCount
        
    }
    
    var voteAverage: String {
        
        return "\(_voteAverage!)/10"
        
    }
    
    func getMovieImageCount() -> Int {
        if _images == nil {
            
            return 0
            
        }
        
        return _images!.count
        
    }
    
    func getURI(index: Int) -> String {
        
        return _images![index]
        
    }
    
    init (movie: NSDictionary)
    {
        _id = "\(String(describing: movie["id"]!))"
        
        if movie["original_language"] as? NSNull == nil {
            
            _originalLanguage = movie["original_language"] as! String
        
        }
        
        if movie["title"] as? NSNull == nil {
            
            _title = movie["title"] as! String
            
        }
        
        if movie["overview"] as? NSNull == nil {
            
            _overview = movie["overview"] as! String
            
        }
        
        _popularity = "\(String(describing: movie["popularity"]))"
        
        if let poster = movie["poster_path"] {
           
            self._posterPath = poster as? String
        
        }
        

        _releaseDate = movie["release_date"] as! String
        
        if let backdrop = movie["backdrop_path"] {
 
            self._backdropPath = backdrop as? String
    
        }
        
        _voteCount = "\(String(describing: movie["vote_count"]!))"
        
        if let vote_average = movie["vote_average"] {
            
            let num = vote_average as! Double
            
            _voteAverage = String(format: "%.1f", num)
        }
        
        
    }
    
    func loadImageURIs(completed: @escaping CompletedDownload) {
        _images = [String]()
        let imagesStr = "\(BASE_URL)\(id)/images?api_key=\(API_KEY)"
        let imagesURL = URL(string: imagesStr)
        let request = URLRequest(url: imagesURL!)
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options: []) as? NSDictionary {
                        for imageURI in (responseDictionary["backdrops"] as? [NSDictionary])! {
                            
                            self._images!.append(imageURI["file_path"] as! String)
                            
                        }
                    }
                }
             completed()
        });
        task.resume()
    }
    
    func loadMovieDetails(completed: @escaping CompletedDownload) {
        
        if _genre == nil {
            
            _genre = [String]()
            
        }
        
        if _productionCompanies == nil {
            
            _productionCompanies = [String]()
            
        }
        
        let url: NSString = "\(BASE_URL)\(_id!)?api_key=\(API_KEY)" as NSString
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStrUrl = URL(string: urlStr!)
        
        let request = URLRequest(url: urlStrUrl!)
        
        let task: URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options: []) as? NSDictionary {
                        if let status = responseDictionary["status"] {
                            
                            self._status = status as! String
                        
                        }
                        
                        if let imdb_id = responseDictionary["imdb_id"] {
                            
                            self._imdbId = imdb_id as! String
                            
                        }
                        
                        if let budgetInt = responseDictionary["budget"] {
                            
                            self._budget = budgetInt as! Int
                            
                        }
                        
                        if let runTimeInt = responseDictionary["runtime"] {
                            
                            self._runtime = runTimeInt as! Int
                            
                        }
                        
                        if let genreArr = responseDictionary["genres"] {

                            for genre in (genreArr as! [NSDictionary])  {
                                
                                if let genreStr = genre["name"] {
                                    
                                    self._genre!.append(genreStr as! String)
                                    
                                }
                                
                            }
                            
                        }
                        
                        if let productionArr = responseDictionary["production_companies"] {
                            
                            for production in (productionArr as! [NSDictionary]) {
                                
                                if let productionStr = production["name"] {
                                    
                                    self._productionCompanies!.append(productionStr as! String)

                                }
                                
                            }
                            
                        }
                        
                    }
                }
            completed()
        })
        task.resume()
        
    }
}
